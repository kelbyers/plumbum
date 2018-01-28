from plumbum.machines import BaseRemoteMachine
from plumbum.machines.session import SessionPopen
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
        if src.is_dir():
            if not dst.exists():
                self._path_mkdir(str(dst))
            for fn in src:
                self._upload(fn, dst / fn.name)
        elif dst.is_dir():
            self._upload(str(src), str(dst / src.name))
        else:
            with open(str(src)) as fl:
                pass
