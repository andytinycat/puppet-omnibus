#!/bin/bash

set -x

# Check for arguments
if [ $# -eq 0 ]; then
    echo >&2 "Usage: $0 <boxtype>"
    exit 1
fi

box_type=$1

function clean_up {
    vagrant destroy -f ${box_type}
}

trap clean_up SIGHUP SIGINT SIGTERM

if [ -d pkg/ ] ; then
    rm -rf pkg/
fi

set -e

vagrant destroy -f ${box_type} || true
vagrant up ${box_type} --destroy-on-error
vagrant ssh ${box_type} -c "sudo /bin/bash -l -c 'rm -rf /tmp/cookery ; cd /vagrant && rbenv shell 1.9.3-p545 && bundle install && BUILD_NUMBER=${BUILD_NUMBER} bundle exec fpm-cook --tmp-root /tmp/cookery"

clean_up
