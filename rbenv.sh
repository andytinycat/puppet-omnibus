#!/bin/bash

set -e

rbenv_version="0.4.0"
ruby_build_version="20140225"
rbenv_bundler_version="0.97"
ruby_version="1.9.3-p545"

install_base="/opt/rbenv"

wget -c https://github.com/sstephenson/rbenv/archive/v${rbenv_version}.zip -O /var/tmp/rbenv.zip
wget -c https://github.com/sstephenson/ruby-build/archive/v${ruby_build_version}.zip -O /var/tmp/ruby-build.zip
wget -c https://github.com/carsomyr/rbenv-bundler/archive/${rbenv_bundler_version}.zip -O /var/tmp/rbenv-bundler.zip
wget -c https://github.com/dcarley/rbenv-sudo/archive/master.zip -O /var/tmp/rbenv-sudo.zip

unzip -o /var/tmp/rbenv.zip -d ${install_base}
mkdir -p ${install_base}/rbenv-${rbenv_version}/plugins

unzip -o /var/tmp/ruby-build.zip -d ${install_base}/rbenv-${rbenv_version}/plugins/
unzip -o /var/tmp/rbenv-sudo.zip -d ${install_base}/rbenv-${rbenv_version}/plugins/

cat >/etc/profile.d/rbenv.sh <<EOF
export RBENV_ROOT="/opt/rbenv/rbenv-${rbenv_version}"
export PATH="\${RBENV_ROOT}/bin:\$PATH"
eval "\$(rbenv init -)"
EOF

export PATH="${install_base}/rbenv-${rbenv_version}/shims:${install_base}/rbenv-${rbenv_version}/bin:${PATH}"
bash -c ". /etc/profile.d/rbenv.sh && rbenv install ${ruby_version}"

export RBENV_ROOT="${install_base}/rbenv-${rbenv_version}"
bash -c ". /etc/profile.d/rbenv.sh && rbenv shell ${ruby_version} && gem install bundler && rbenv rehash"

