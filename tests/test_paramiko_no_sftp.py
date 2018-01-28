import pytest

try:
    import paramiko
except ImportError:
    paramiko = None
else:
    from plumbum.machines.paramiko_no_sftp_machine import ParamikoNoSftpMachine
    from plumbum.machines.paramiko_no_sftp import ParamikoNoSftp

from test_remote import TestParamikoMachine, TEST_HOST


skip_no_paramiko = pytest.mark.skipif(
    not paramiko,
    reason="paramiko required for this test"
)

@skip_no_paramiko
class TestParamikoNoSftpMachine(TestParamikoMachine):
    def _connect(self):
        if paramiko is None:
            pytest.skip("System does not have paramiko installed")
        return ParamikoNoSftpMachine(TEST_HOST, missing_host_policy=paramiko.AutoAddPolicy())

@skip_no_paramiko
class TestParamikoNoSftp:
    def test_class(self, mocker):
        mach = mocker.MagicMock()
        sftp = ParamikoNoSftp(mach)

        assert sftp.machine == mach

    # def test_
