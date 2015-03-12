#!/usr/bin/env bash
#
# Install and run librarian-puppet/r10k

set -e

PUPPET_DIR=/etc/puppet/
PUPPET_ENV_DIR=${PUPPET_DIR}/environments
PUPPETFILE_SRC=/tmp/Puppetfile

if [ ! -d "${PUPPET_DIR}" ]; then
    echo "creating ${PUPPET_DIR}"
    mkdir ${PUPPET_DIR}
fi

if [ ! -d "${PUPPET_ENV_DIR}" ]; then
    echo "creating ${PUPPET_ENV_DIR}"
    mkdir ${PUPPET_ENV_DIR}
fi

if [ ! -f "${PUPPETFILE_SRC}" ]; then
   echo "unable to find the puppetfile ${PUPPETFILE_SRC}"
   exit 1
fi

echo "copying ${PUPPETFILE_SRC} to ${PUPPET_DIR}"
cp ${PUPPETFILE_SRC} ${PUPPET_DIR}

echo "Installing puppet modules..."
cd ${PUPPET_DIR} && r10k puppetfile install
