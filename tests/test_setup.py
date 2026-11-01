"""Behavior tests with real Bash 3.2 and Git, isolated homes, and offline package/app mocks."""
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


class SetupTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='mac setup tests ')
        self.addCleanup(self.temp.cleanup)
        self.base = Path(self.temp.name)
        self.home = self.base / 'home with spaces'
        self.home.mkdir()
        self.repo = self.base / 'repo with spaces'
        shutil.copytree(ROOT, self.repo, ignore=shutil.ignore_patterns('.git', '__pycache__'))
        self.bin = self.base / 'bin'
        self.bin.mkdir()
        self.shim = self.bin / 'shim'
        self.shim.write_text('#!' + sys.executable + '\n' + (ROOT / 'tests/fake_tool.py').read_text())
        self.shim.chmod(0o755)
        for name in ('brew', 'uname', 'id', 'uv', 'npm', 'go', 'gh', 'node'):
            (self.bin / name).symlink_to(self.shim)
        self.apps = self.base / 'Applications'
        code = self.apps / 'Visual Studio Code.app/Contents/Resources/app/bin/code'
        code.parent.mkdir(parents=True)
        code.symlink_to(self.shim)
        self.state = self.base / 'state.json'
        self.calls = self.base / 'calls.jsonl'
        self.env = {key: value for key, value in os.environ.items() if key in ('TMPDIR', 'LANG')}
        self.env.update({
            'HOME': str(self.home), 'PATH': str(self.bin) + ':/usr/bin:/bin:/usr/sbin:/sbin',
            'BREW': str(self.bin / 'brew'), 'FAKE_BIN': str(self.bin), 'FAKE_STATE': str(self.state),
            'FAKE_CALLS': str(self.calls), 'REAL_NODE': shutil.which('node'),
            'APPLICATIONS_DIR': str(self.apps), 'USE_SUDO': '0', 'GIT_NAME': 'Test User',
            'GIT_EMAIL': 'test@example.invalid', 'GIT_CONFIG_NOSYSTEM': '1',
        })

    def run_script(self, script='setup-mac.sh', *args, **overrides):
        return subprocess.run(
            ['/bin/bash', str(self.repo / script), *args], env={**self.env, **overrides},
            text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=90,
        )

    def records(self):
        directories = sorted((self.home / 'Library/Logs/mac-setup').glob('run-*'), key=lambda p: p.stat().st_mtime_ns)
        return (directories[-1] / 'results.tsv').read_text().splitlines()

    def call_list(self):
        return [json.loads(line) for line in self.calls.read_text().splitlines()]

    def assert_success(self, process):
        self.assertEqual(process.returncode, 0, process.stdout)
        self.assertFalse((self.home / 'Library/Logs/mac-setup/running.lock').exists())
        self.assertTrue(all(len(line) <= 120 for line in process.stdout.splitlines()), process.stdout)

    def home_snapshot(self):
        snapshot = {}
        for path in self.home.rglob('*'):
            relative = path.relative_to(self.home)
            if relative.parts[:2] == ('Library', 'Logs'):
                continue
            metadata = path.lstat()
            if path.is_symlink():
                data = ('link', os.readlink(path))
            elif path.is_file():
                data = ('file', path.read_bytes())
            else:
                continue
            snapshot[str(relative)] = (data, metadata.st_mode, metadata.st_mtime_ns)
        return snapshot

    def assert_no_installations(self, calls):
        self.assertFalse(any(call[:2] in (
            ['brew', 'install'], ['brew', 'upgrade'], ['brew', 'update'], ['npm', 'install'],
            ['npm', 'rebuild'], ['go', 'install'], ['code', '--install-extension'],
        ) or call[:3] == ['uv', 'python', 'install'] or (call[:2] == ['brew', 'tap'] and len(call) > 2)
            for call in calls), calls)

    def test_fresh_setup_and_repeat_run(self):
        first = self.run_script()
        self.assert_success(first)
        records = self.records()
        self.assertTrue(any(line.startswith('INSTALLED\tgit ') for line in records))
        self.assertTrue(any('Homebrew tap: typewhisper/tap' in line for line in records))
        self.assertTrue(any(line.startswith('INSTALLED\ttypewhisper ') for line in records))
        self.assertTrue(any('VS Code extension: ms-python.python@' in line for line in records))
        settings = json.loads((self.home / 'Library/Application Support/Code/User/settings.json').read_text())
        self.assertEqual(settings['python.defaultInterpreterPath'], str(self.home / '.local/bin/python'))
        self.assertIn('--appdir=' + str(self.apps), next(
            call for call in self.call_list() if call[:3] == ['brew', 'install', '--cask']
        ))
        snapshot = self.home_snapshot()
        initial_calls = len(self.call_list())
        second = self.run_script()
        self.assert_success(second)
        new_calls = self.call_list()[initial_calls:]
        self.assertEqual(self.home_snapshot(), snapshot)
        self.assert_no_installations(new_calls)
        third = self.run_script(LATEST_PYTHON='3.15.0')
        self.assert_success(third)
        self.assertEqual(self.home_snapshot(), snapshot)
        self.assert_no_installations(self.call_list()[initial_calls:])
        self.assertFalse(any(row.startswith(('INSTALLED\t', 'CONFIGURED\t')) for row in self.records()))
        self.assertFalse(any(call[:2] == ['brew', 'install'] for call in new_calls))
        self.assertFalse(any(call[:2] == ['npm', 'install'] for call in new_calls))
        self.assertFalse(any(call[:2] == ['code', '--install-extension'] for call in new_calls))
        self.assertEqual((self.home / '.zprofile').read_text().count('mac-setup/env.sh'), 2)
        self.assertTrue(any(line.startswith('PRESENT\tgit ') for line in self.records()))
        self.assertTrue(any(line.startswith('PRESERVED\tVS Code settings') for line in self.records()))
        # Full installer output stays intact in logs despite wrapped status output.
        logs = list((self.home / 'Library/Logs/mac-setup').glob('run-*/*.log'))
        self.assertTrue(any('x' * 180 in log.read_text() for log in logs))

    def test_each_standalone_task_is_idempotent(self):
        tasks = ('bootstrap', 'packages', 'python', 'pi', 'shell', 'git', 'templates', 'vscode', 'ghostty')
        for task in tasks:
            with self.subTest(task=task):
                self.assert_success(self.run_script('scripts/' + task + '.sh'))
                snapshot = self.home_snapshot()
                initial_calls = len(self.call_list())
                self.assert_success(self.run_script('scripts/' + task + '.sh'))
                self.assertEqual(self.home_snapshot(), snapshot)
                self.assert_no_installations(self.call_list()[initial_calls:])

    def test_failed_run_recovers_without_reinstalling_successful_items(self):
        first = self.run_script(FAIL_PACKAGE='deno', FAIL_EXTENSION='ms-python.python')
        self.assertNotEqual(first.returncode, 0)
        snapshot = self.home_snapshot()
        initial_calls = len(self.call_list())
        self.assert_success(self.run_script())
        calls = self.call_list()[initial_calls:]
        packages = [call[-1] for call in calls if call[:2] == ['brew', 'install']]
        extensions = [call[-1] for call in calls if call[:2] == ['code', '--install-extension']]
        self.assertEqual(packages, ['deno'])
        self.assertEqual(extensions, ['ms-python.python'])
        self.assertEqual(self.home_snapshot(), snapshot)
        initial_calls = len(self.call_list())
        self.assert_success(self.run_script())
        self.assertEqual(self.home_snapshot(), snapshot)
        self.assert_no_installations(self.call_list()[initial_calls:])

    def test_missing_python_default_is_repaired_without_downloading_python(self):
        self.assert_success(self.run_script('scripts/python.sh'))
        default = self.home / '.local/bin/python3'
        default.unlink()
        initial_calls = len(self.call_list())
        self.assert_success(self.run_script('scripts/python.sh'))
        self.assertTrue(default.is_symlink())
        self.assert_no_installations(self.call_list()[initial_calls:])
        snapshot = self.home_snapshot()
        self.assert_success(self.run_script('scripts/python.sh'))
        self.assertEqual(self.home_snapshot(), snapshot)

    def test_explicit_python_version_change_retargets_only_owned_defaults(self):
        self.assert_success(self.run_script('scripts/python.sh', PYTHON_VERSION='3.13.0'))
        self.assert_success(self.run_script('scripts/python.sh', PYTHON_VERSION='3.14.0'))
        for name in ('python', 'python3'):
            self.assertIn('/3.14.0/', os.readlink(self.home / '.local/bin' / name))
        snapshot = self.home_snapshot()
        initial_calls = len(self.call_list())
        self.assert_success(self.run_script('scripts/python.sh', PYTHON_VERSION='3.14.0'))
        self.assertEqual(self.home_snapshot(), snapshot)
        self.assert_no_installations(self.call_list()[initial_calls:])

    def test_conflicting_python_command_is_not_overwritten(self):
        default = self.home / '.local/bin/python'
        default.parent.mkdir(parents=True)
        default.write_text('personal command\n')
        before = (default.read_bytes(), default.stat().st_mtime_ns)
        process = self.run_script('scripts/python.sh')
        self.assertNotEqual(process.returncode, 0)
        self.assertIn('Python default conflicts', process.stdout)
        self.assertEqual((default.read_bytes(), default.stat().st_mtime_ns), before)

    def test_registered_pi_with_missing_command_is_repaired_without_upgrade(self):
        self.assert_success(self.run_script('scripts/pi.sh'))
        (self.home / '.local/bin/pi').unlink()
        initial_calls = len(self.call_list())
        self.assert_success(self.run_script('scripts/pi.sh'))
        calls = self.call_list()[initial_calls:]
        self.assertTrue(any(call[:2] == ['npm', 'rebuild'] for call in calls))
        self.assertFalse(any(call[:2] == ['npm', 'install'] for call in calls))
        snapshot = self.home_snapshot()
        initial_calls = len(self.call_list())
        self.assert_success(self.run_script('scripts/pi.sh'))
        self.assertEqual(self.home_snapshot(), snapshot)
        self.assert_no_installations(self.call_list()[initial_calls:])

    def test_duplicate_extension_entry_does_not_install_twice(self):
        manifest = self.repo / 'config/vscode/extensions.txt'
        manifest.write_text(manifest.read_text() + '\nms-python.python\n')
        self.assert_success(self.run_script('scripts/vscode.sh'))
        installs = [call for call in self.call_list() if call[:2] == ['code', '--install-extension']]
        self.assertEqual(sum(call[-1] == 'ms-python.python' for call in installs), 1)

    def test_shell_environment_does_not_duplicate_path_entries(self):
        self.assert_success(self.run_script('scripts/shell.sh'))
        envfile = self.home / '.config/mac-setup/env.sh'
        process = subprocess.run(
            ['/bin/bash', '-c', '. "$1"; . "$1"; printf "%s\\n" "$PATH"', 'check', str(envfile)],
            env=self.env, text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True,
        )
        self.assertEqual(process.stdout.strip().split(':').count(str(self.home / '.local/bin')), 1)

    def test_existing_personal_settings_are_preserved(self):
        user = self.home / 'Library/Application Support/Code/User'
        user.mkdir(parents=True)
        (user / 'settings.json').write_text('// JSONC personal settings\n{"editor.fontSize": 18}\n')
        (user / 'keybindings.json').write_text('// personal keybindings\n[]\n')
        ghostty = self.home / 'Library/Application Support/com.mitchellh.ghostty/config.ghostty'
        ghostty.parent.mkdir(parents=True)
        ghostty.write_text('font-size = 20\n')
        self.assert_success(self.run_script())
        self.assertTrue((user / 'settings.json').read_text().startswith('// JSONC'))
        self.assertTrue((user / 'keybindings.json').read_text().startswith('// personal'))
        self.assertEqual(ghostty.read_text(), 'font-size = 20\n')
        self.assertTrue(any(line.startswith('PRESERVED\tGhostty') for line in self.records()))

    def test_package_failure_continues_and_returns_failure(self):
        process = self.run_script(FAIL_PACKAGE='deno')
        self.assertNotEqual(process.returncode, 0)
        self.assertIn('[FAILED] Install deno', process.stdout)
        self.assertIn('[INSTALLED] go ', process.stdout)
        self.assertIn('[CONFIGURED] C++ starter', process.stdout)
        self.assertFalse((self.home / 'Library/Logs/mac-setup/running.lock').exists())

    def test_installer_success_without_installation_is_rejected(self):
        process = self.run_script('scripts/packages.sh', LIE_PACKAGE='git')
        self.assertNotEqual(process.returncode, 0)
        self.assertIn('[FAILED] Verify git', process.stdout)
        self.assertNotIn('[INSTALLED] git ', process.stdout)

    def test_empty_verification_output_is_rejected(self):
        process = self.run_script('scripts/packages.sh', EMPTY_VERSION='git')
        self.assertNotEqual(process.returncode, 0)
        self.assertIn('git: no installed version found', process.stdout)

    def test_standalone_python_and_missing_prerequisite(self):
        self.assert_success(self.run_script('scripts/python.sh'))
        (self.bin / 'uv').unlink()
        process = self.run_script('scripts/python.sh')
        self.assertNotEqual(process.returncode, 0)
        self.assertIn('[BLOCKED] python requires uv', process.stdout)

    def test_standalone_tasks(self):
        for task in ('bootstrap', 'packages', 'pi', 'shell', 'git', 'templates', 'vscode', 'ghostty'):
            with self.subTest(task=task):
                self.assert_success(self.run_script('scripts/' + task + '.sh'))

    def test_bootstrap_failure_stops_other_installers(self):
        process = self.run_script(FAIL_BOOTSTRAP='1')
        self.assertNotEqual(process.returncode, 0)
        self.assertIn('Bootstrap failed', process.stdout)
        self.assertFalse(any(call[:2] == ['brew', 'install'] for call in self.call_list()))
        self.assertFalse((self.home / 'Library/Logs/mac-setup/running.lock').exists())

    def test_missing_python_prerequisite_blocks_python_only(self):
        (self.bin / 'uv').unlink()
        process = self.run_script(FAIL_PACKAGE='uv')
        self.assertNotEqual(process.returncode, 0)
        self.assertIn('[BLOCKED] python requires uv', process.stdout)
        self.assertIn('[CONFIGURED] C++ starter', process.stdout)

    def test_extension_failure_continues(self):
        process = self.run_script(FAIL_EXTENSION='ms-python.python')
        self.assertNotEqual(process.returncode, 0)
        self.assertIn('[FAILED] Install extension ms-python.python', process.stdout)
        self.assertIn('VS Code extension: ms-python.vscode-pylance@', process.stdout)

    def test_doctor_warning_is_advisory(self):
        process = self.run_script(FAIL_DOCTOR='1')
        self.assert_success(process)
        self.assertIn('advisory warnings', process.stdout)

    def test_metadata_update_failure_is_not_hidden(self):
        process = self.run_script(FAIL_UPDATE='1', UPDATE_HOMEBREW='1')
        self.assertNotEqual(process.returncode, 0)
        self.assertIn('[FAILED] Update Homebrew metadata', process.stdout)
        self.assertIn('[CONFIGURED] C++ starter', process.stdout)

    def test_optional_toolchains(self):
        self.assert_success(self.run_script('scripts/packages.sh', INSTALL_GCC='1', INSTALL_RUST_TOOLCHAIN='1'))
        self.assertIn('gcc', json.loads(self.state.read_text())['packages'])
        self.assertIn('rust', json.loads(self.state.read_text())['packages'])

    def test_help_and_preview_do_not_modify_home(self):
        for option in ('--dry-run', '--list', '--help'):
            self.assertEqual(self.run_script('setup-mac.sh', option).returncode, 0)
        self.assertEqual(list(self.home.iterdir()), [])
        self.assertFalse(self.calls.exists())
        self.assertEqual(self.run_script('setup-mac.sh', '--help', '--verbose').returncode, 2)
        self.assertEqual(self.run_script('setup-mac.sh', '--unknown').returncode, 2)

    def test_existing_lock_blocks_run_without_removing_lock(self):
        lock = self.home / 'Library/Logs/mac-setup/running.lock'
        lock.mkdir(parents=True)
        process = self.run_script()
        self.assertNotEqual(process.returncode, 0)
        self.assertTrue(lock.exists())
        self.assertTrue(all(call[0] in ('uname', 'id') for call in self.call_list()))


if __name__ == '__main__':
    unittest.main(verbosity=2)
