set -x

APT_GET="DEBIAN_FRONTEND=noninteractive apt-get -y"

sudo ${APT_GET} update
sudo ${APT_GET} upgrade
sudo ${APT_GET} install ruby1.9.1 ruby1.9.1-dev build-essential gawk git curl
sudo gem install bundler --no-rdoc --no-ri

cd /vagrant
bundler install
