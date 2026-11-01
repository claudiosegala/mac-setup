#!/bin/bash
# Repository checks only; never runs real installers.
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
cd "$root"
for file in setup-mac.sh scripts/*.sh config/options.sh; do /bin/bash -n "$file"; done
shellcheck -x -P "$root" setup-mac.sh scripts/*.sh config/options.sh
python3 - <<'PY'
import json
from pathlib import Path
root = Path('.')
paths = [root / 'README.md', root / 'Brewfile', root / 'setup-mac.sh', root / '.gitignore']
for directory in ('scripts', 'config', 'tests', '.github'):
    paths.extend(p for p in (root / directory).rglob('*') if p.is_file() and '__pycache__' not in p.parts)
errors = []
for path in paths:
    for number, line in enumerate(path.read_text().splitlines(), 1):
        if len(line) > 120:
            errors.append(f'{path}:{number}: {len(line)} characters (maximum 120)')
for path in (root / 'config').rglob('*.json'):
    json.loads(path.read_text())
if errors:
    raise SystemExit('\n'.join(errors))
print('PASS: Bash syntax, ShellCheck, JSON, and 120-character limit')
PY
build=$(mktemp -d)
trap 'rm -rf "$build"' EXIT
clang++ -std=c++20 -O2 -Wall -Wextra config/icpc/code.cpp -o "$build/main"
"$build/main"
PYTHONDONTWRITEBYTECODE=1 python3 tests/test_setup.py
