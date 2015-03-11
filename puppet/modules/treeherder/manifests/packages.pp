class treeherder::packages {
  # packer does install from ../puppet/modules/treeherder
  # r10k adds puppet module to /etc/puppet
  # terraform enables services via puppet apply on boot (or remote-exec)

  package {
    [
      'python2.7',
      'python2.7-dev',
      'libpython2.7',
      'python-pip',
      'python-setuptools',
      'mysql-client',
      'mysql-common',
      'make',
      'apache2',
      'rabbitmq-server',
    ]:
      ensure => present;
  }

  package {
    'peep':
      ensure   => '2.2',
      provider => 'pip'
  }

  #  file {
  #  'peep-requirements':
  #    ensure => present,
  #    owner  => 'root',
  #    group  => 'root',
  #    mode   => '0644',
  #    source => "puppet:///modules/${module_name}/root/peep-requirements.txt";
  #}
  #
  #exec {
  #  'install_peep_requirements':
  #    path    => '/bin:/usr/bin:/sbin:/usr/sbin',
  #    command => "peep install --index-url=http://bucket -r ${peep-requirements}",
  #    onlyif  => "test -f ${peep-requirements}";
  #}
}
