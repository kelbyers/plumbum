#!/bin/bash

# pre-requisites for building python
sudo apt-get update
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev

# install pyenv if not present
[[ -d ~/.pyenv ]] || {
    INSTALLED=1
    curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
}
[[ -d ~/.pyenv/plugins/pyenv-update ]] ||
    git clone git://github.com/pyenv/pyenv-update.git ~/.pyenv/plugins/pyenv-update

# update pyenv if needed
(( ${INSTALLED-0}  == 0 )) &&
(
    export PATH="/home/vagrant/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
    pyenv update
)

# set up ssh
grep -q "NoHostAuthenticationForLocalhost yes" ~/.ssh/config ||
    echo NoHostAuthenticationForLocalhost yes >> ~/.ssh/config
grep -q "StrictHostKeyChecking no" ~/.ssh/config ||
    echo StrictHostKeyChecking no >> ~/.ssh/config
[[ -f ~/.ssh/id_rsa ]] ||
    ssh-keygen -q -f ~/.ssh/id_rsa -N ''
grep -q "$(<~/.ssh/id_rsa.pub)" ~/.ssh/authorized_keys ||
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod go-w ~/.ssh/*

grep -q pyenv ~/.bash_profile || cat <<'EOF' >> ~/.bash_profile

# activate pyenv so we can install some versions
export PATH="/home/vagrant/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
EOF

# activate pyenv so we can install some versions
export PATH="/home/vagrant/.pyenv/bin:$PATH"
eval "$(pyenv init -)"

# install python versions
for VERSION in 2.6.9 2.7.14 3.4.7 3.5.4 3.6.4; do
    pyenv install --skip-existing $VERSION
    pyenv shell $VERSION
    pip install virtualenv
done

[[ -f ~/setup ]] || cat <<'EOF' > ~/setup
for ENV in $(pyenv versions --bare); do
    [[ -d ~/${ENV} ]] || {
        virtualenv ~/${ENV}
        ~/${ENV}/bin/pip install -r /vagrant/plumbum/dev-requirements.txt -r /vagrant/plumbum/dev-requirements-extra.txt
        ~/${ENV}/bin/pip install -e /vagrant/plumbum
    }
done
EOF
chmod +x ~/setup

[[ -f ~/runtests.sh ]] || cat <<'EOF' > ~/runtests.sh
ENVLIST="${ENVLIST-$(pyenv versions --bare)}"
find tests -name '__pycache__' | xargs rm -rf
for ENV in $ENVLIST; do
    ~/${ENV}/bin/py.test -n 5 -x || {
        echo failed in $ENV
        break
    }
done
EOF
chmod +x ~/runtests.sh
