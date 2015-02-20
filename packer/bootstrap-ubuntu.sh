#!/usr/bin/env bash

log() {
    # todo: log to file?
    STAMP=`date '+%F %T %z'`
    echo "${STAMP} BOOTSTRAP: ${@}"
}

log "start"
log "install puppet repo"
wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb
dpkg -i puppetlabs-release-precise.deb

log "apt-get update"
apt-get -y update

log "apt-get upgrade"
apt-get -y dist-upgrade

log "apt-get install puppet"
apt-get -y install puppet

log "end"
