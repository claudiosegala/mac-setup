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
        initial_calls = len(self.call_list())
        second = self.run_script()
        self.assert_success(second)
        new_calls = self.call_list()[initial_calls:]
        self.assertFalse(any(call[:2] == ['brew', 'install'] for call in new_calls))
        self.assertFalse(any(call[:2] == ['npm', 'install'] for call in new_calls))
        self.assertFalse(any(call[:2] == ['code', '--install-extension'] for call in new_calls))
        self.assertEqual((self.home / '.zprofile').read_text().count('mac-setup/env.sh'), 2)
        self.assertTrue(any(line.startswith('PRESENT\tgit ') for line in self.records()))
        self.assertTrue(any(line.startswith('PRESERVED\tVS Code settings') for line in self.records()))
        # Full installer output stays intact in logs despite wrapped status output.
        logs = list((self.home / 'Library/Logs/mac-setup').glob('run-*/*.log'))
        self.assertTrue(any('x' * 180 in log.read_text() for log in logs))

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
        process = self.run_script(FAIL_UPDATE='1')
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
