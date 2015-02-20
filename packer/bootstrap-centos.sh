#!/usr/bin/env bash

log() {
    # todo: log to file?
    STAMP=`date '+%F %T %z'`
    echo "${STAMP} BOOTSTRAP: ${@}"
}

log "start"
log "install puppet repo"
rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm

log "yum check-update"
yum check-update

log "yum upgrade"
yum -y upgrade

log "yum install puppet"
yum -y install puppet

log "end"
