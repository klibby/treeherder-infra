class treeherder::install {
  # packer does install from ../puppet/modules/treeherder
  # r10k adds puppet module to /etc/puppet
  # terraform enables services via puppet apply on boot (or remote-exec)

  include treeherder::packages

  # setup directories, etc..
  file {
    [
     '/data',
     '/data/www',
    ]:
      ensure => directory;
  }
}
