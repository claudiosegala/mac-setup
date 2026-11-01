"""Offline installers for the integration tests; all writes stay in their temporary home."""
import json
import os
from pathlib import Path
import re
import shlex
import subprocess
import sys

name = Path(sys.argv[0]).name
args = sys.argv[1:]
home = Path(os.environ['HOME'])
state_file = Path(os.environ['FAKE_STATE'])
state = json.loads(state_file.read_text()) if state_file.exists() else {'packages': {}, 'extensions': []}
with Path(os.environ['FAKE_CALLS']).open('a') as calls:
    calls.write(json.dumps([name, *args]) + '\n')


def save():
    state_file.write_text(json.dumps(state))


def executable(path, text):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text('#!/bin/bash\nprintf \'%s\\n\' ' + shlex.quote(text) + '\n')
    path.chmod(0o755)


def fail():
    print('Simulated failure: ' + name, file=sys.stderr)
    sys.exit(17)


if name == 'uname':
    print('Darwin')
elif name == 'id':
    print('1000')
elif name == 'node':
    sys.exit(subprocess.call([os.environ['REAL_NODE'], *args]))
elif name == 'brew':
    if args == ['shellenv']:
        paths = dict.fromkeys([os.environ['FAKE_BIN'], *os.environ['PATH'].split(':')])
        print('export PATH=' + shlex.quote(':'.join(paths)))
    elif args == ['--version']:
        if os.environ.get('FAIL_BOOTSTRAP'):
            fail()
        print('Homebrew test')
    elif args == ['update']:
        if os.environ.get('FAIL_UPDATE'):
            fail()
    elif args == ['doctor']:
        if os.environ.get('FAIL_DOCTOR'):
            fail()
    elif args[:2] == ['bundle', 'list']:
        kind = 'brew' if '--formula' in args else ('tap' if '--tap' in args else 'cask')
        brewfile = next(arg.split('=', 1)[1] for arg in args if arg.startswith('--file='))
        for line in Path(brewfile).read_text().splitlines():
            match = re.match(kind + r' "([^"]+)"', line)
            if match:
                print(match[1].rsplit('/', 1)[-1] if kind == 'cask' else match[1])
    elif args[0] == 'tap':
        if len(args) == 1:
            print('\n'.join(state.get('taps', [])))
        else:
            state.setdefault('taps', []).append(args[1])
            save()
    elif args[0] == 'list':
        package = args[-1]
        if package not in state['packages']:
            sys.exit(1)
        if package != os.environ.get('EMPTY_VERSION'):
            print(package + ' ' + state['packages'][package])
    elif args[0] == 'install':
        package = args[-1]
        if package == 'typewhisper' and 'typewhisper/tap' not in state.get('taps', []):
            fail()
        if package == os.environ.get('FAIL_PACKAGE'):
            fail()
        if package != os.environ.get('LIE_PACKAGE'):
            state['packages'][package.rsplit('/', 1)[-1]] = '1.2.3'
            save()
        print('Raw install output ' + 'x' * 180)
    else:
        raise RuntimeError(args)
elif name == 'uv':
    request = args[2]
    versions = state.get('pythons', [])
    matching = [v for v in versions if v == request or v.startswith(request + '.')]
    if args[:2] == ['python', 'find']:
        if not matching:
            sys.exit(1)
        version = sorted(matching, key=lambda v: tuple(map(int, v.split('.'))))[-1]
        interpreter = home / '.local/share/uv/python' / version / 'bin/python3'
        if not interpreter.exists():
            sys.exit(1)
        print(interpreter)
    elif args[:2] == ['python', 'install']:
        if os.environ.get('FAIL_PYTHON'):
            fail()
        version = request if re.fullmatch(r'\d+\.\d+\.\d+', request) else os.environ.get('LATEST_PYTHON', '3.14.0')
        interpreter = home / '.local/share/uv/python' / version / 'bin/python3'
        executable(interpreter, 'Python ' + version)
        state.setdefault('pythons', []).append(version)
        save()
        if '--no-bin' not in args:
            for default in ('python', 'python3'):
                executable(home / '.local/bin' / default, 'Python ' + version)
    else:
        raise RuntimeError(args)
elif name == 'npm':
    if args[0] == 'list':
        sys.exit(0 if state.get('pi') else 1)
    elif args[0] in ('install', 'rebuild'):
        executable(home / '.local/bin/pi', 'pi 1.0.0')
        state['pi'] = True
        save()
    else:
        raise RuntimeError(args)
elif name == 'code':
    if args == ['--version']:
        print('1.100.0')
    elif args[0] == '--list-extensions':
        for extension in state['extensions']:
            print(extension + ('@1.0.0' if '--show-versions' in args else ''))
    elif args[0] == '--install-extension':
        if args[1] == os.environ.get('FAIL_EXTENSION'):
            fail()
        state['extensions'].append(args[1])
        save()
    else:
        raise RuntimeError(args)
elif name == 'go':
    executable(Path(os.environ['GOBIN']) / 'gopls', 'golang.org/x/tools/gopls v0.20.0')
elif name == 'gh':
    if args[:3] == ['config', 'get', 'editor']:
        if 'editor' not in state:
            sys.exit(1)
        print(state['editor'])
    elif args[:3] == ['config', 'set', 'editor']:
        state['editor'] = args[3]
        save()
    else:
        raise RuntimeError(args)
else:
    raise RuntimeError(name)
