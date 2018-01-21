#!/bin/bash

# yum install pre-requisites
sudo yum groupinstall -y "development tools"
sudo yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel expat-devel
sudo yum install -y git curl wget

# install pyenv if not present
[[ -d ~/.pyenv ]] || curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash

# set up ssh
grep -q "NoHostAuthenticationForLocalhost yes" ~/.ssh/config ||
    echo NoHostAuthenticationForLocalhost yes >> ~/.ssh/config
grep -q "StrictHostKeyChecking no" ~/.ssh/config ||
    echo StrictHostKeyChecking no >> ~/.ssh/config
[[ -f ~/.ssh/id_rsa ]] ||
    ssh-keygen -q -f ~/.ssh/id_rsa -N ''
grep $(<~/.ssh/id_rsa.pub) ~/.ssh/authorized_keys ||
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod go-w ~/.ssh/*

# activate pyenv so we can install some versions
export PATH="/home/vagrant/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# install python versions
for VERSION in 2.6.9 2.7.14 3.4.7 3.5.4 3.6.4; do
    pyenv install --skip-existing $VERSION
    pyenv shell $VERSION
    pip install tox tox-pyenv
done
