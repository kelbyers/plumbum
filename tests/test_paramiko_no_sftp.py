import pytest

try:
    import paramiko
except ImportError:
    paramiko = None
else:
    from plumbum.machines.paramiko_no_sftp_machine import ParamikoNoSftpMachine
    from plumbum.machines.paramiko_no_sftp import ParamikoNoSftp
    from plumbum.machines.paramiko_machine import ParamikoMachine

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

# @skip_no_paramiko
# class TestParamikoNsmMock:
#     def _connect(self, mocker):
#         if paramiko is None:
#             pytest.skip("System does not have paramiko installed")
#         with mocker.patch('plumbum.machines.paramiko_no_sftp_machine.ParamikoMachine.__init__') as m_init:
#             m_init.return_value = None
#             mach = ParamikoNoSftpMachine(TEST_HOST, missing_host_policy=paramiko.AutoAddPolicy())
#         mach._fqhost = 'testhost'
#
#     def test__listdir(self, mocker):
#         with self._connect(mocker) as rem, mocker.patch('plumbum.machines.paramiko_no_sftp_machine.BaseRemoteMachine._listdir') as m_listdir:
#             dirname = mocker.MagicMock()
#             my_list = rem._listdir(dirname)
#             m_listdir.assert_called_with(dirname)
#             assert my_list == m_listdir.return_value
