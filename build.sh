#!/bin/bash

set +x

supported_distros="centos6 ubuntu12"

## FUNCTIONS

usage() {
    echo
    echo "Usage: `basename $0` -d distro -v version [-t]"
    echo
    echo "Example: `basename $0` -d centos6 -v 3"
    echo
    echo "-t test flag, don't destroy the vagrant instance after build" 
    echo
}

clean_up() {
    box_type=$1
    vagrant destroy -f ${box_type}
}


## MAIN


# process command line arguments
testing=false

if [ "$1" = "" ]; then
    usage
    exit 1
fi

while [ "$1" != "" ]; do
    case $1 in
        -d ) shift
             distro=$1
             ;;
        -v ) shift
             version=$1
             ;;
        -t ) testing=true
             ;;
        * ) usage
            exit 1
    esac
    shift
done

# make sure mandatory options are set
if [ "x$distro" = 'x' ]; then
    echo "ERROR: missing distro argument"
    usage
    exit 1
fi

if [ "x$version" = 'x' ]; then
    echo "ERROR: missing version argument"
    usage
    exit 1
fi 

# check if given distro is supported for this package
if [ ! "`echo "${supported_distros}" | grep $distro`" ]; then
    echo "ERROR: ${distro} isn't supported by this package"
    exit 2
fi


trap "clean_up $distro" SIGHUP SIGINT SIGTERM


if [ -d pkg/ ] ; then
    rm -rf pkg/
fi


set -e

if [ $testing = false ]; then
    clean_up $distro || true
fi

vagrant up ${distro} --destroy-on-error
vagrant ssh ${distro} -c "sudo /bin/bash -l -c 'rm -rf /tmp/cookery ; cd /vagrant && rbenv shell 1.9.3-p545 && bundle install && PKG_VERSION=${version} bundle exec fpm-cook --tmp-root /tmp/cookery'"
retval=$?

if [ $testing = false ]; then
    clean_up $distro
fi

exit $retval
