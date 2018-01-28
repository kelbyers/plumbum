from plumbum.machines import BaseRemoteMachine
from plumbum.machines.paramiko_machine import ParamikoMachine


class ParamikoNoSftpMachine(ParamikoMachine):
    def _download(self, src, dst):
        BaseRemoteMachine.download(self, src, dst)

    def _path_listdir(self, fn):
        return BaseRemoteMachine._path_listdir(self, fn)

    def _path_read(self, fn):
        return BaseRemoteMachine._path_read(self, fn)

    def _path_stat(self, fn):
        return BaseRemoteMachine._path_stat(self, fn)

    def _path_write(self, fn, data):
        BaseRemoteMachine._path_write(self, fn, data)

    def _upload(self, src, dst):
        BaseRemoteMachine.upload(self, src, dst)
