class treeherder::install {
  # packer does install from ../puppet/modules/treeherder
  # r10k adds puppet modules to /etc/puppet
  # terraform enables services via puppet apply on boot (or remote-exec)

  user {
    'treeherder':
      ensure => present,
      home   => '/data';
  }

  package {
    [
      'git',
      'python2.7',
      'python2.7-dev',
      'libpython2.7',
      'python-pip',
      'python-setuptools',
      'mysql-client',
      'mysql-common',
      'libmysqlclient-dev',
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

  file {
    '/data':
      ensure  => directory,
      owner   => 'treeherder',
      group   => 'treeherder',
      mode    => '0755',
      require => User['treeherder'];
  }

  exec {
    'checkout_treeherder_service':
      command => 'git clone https://github.com/mozilla/treeherder-service',
      cwd     => '/data',
      path    => '/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin',
      unless  => 'test -f /data/treeherder-service/.git/index',
      require => [ Package['git'], File['/data'] ];
  }

  exec {
    'checkout_treeherder_ui':
      command => 'git clone https://github.com/mozilla/treeherder-ui',
      cwd     => '/data',
      path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
      unless  => 'test -f /data/treeherder-ui/.git/index',
      require => [ Package['git'], File['/data'] ];
  }

  # I think this will eventually be wrapped up into one file in the -service repo
  # current as of bfb7f690b708b9474b365332c6a06fcbaaee479c
  file {
    '/data/peep-checkedin.txt':
      ensure => present,
      source => "puppet:///modules/${module_name}/files/peep-checkedin.txt";
    '/data/peep-common.txt':
      ensure => present,
      source => "puppet:///modules/${module_name}/files/peep-common.txt";
    '/data/peep-prod.txt':
      ensure => present,
      source => "puppet:///modules/${module_name}/files/peep-prod.txt";
  }

  exec {
    'install_checkedin_requirements':
      path    => '/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin',
      command => 'peep install -r /data/peep-checkedin.txt',
      onlyif  => 'test -f /data/peep-checkedin.txt',
      require => [ File['/data/peep-checkedin.txt'], Package['peep'] ];

    'install_common_requirements':
      path    => '/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin',
      command => 'peep install -r /data/peep-common.txt',
      onlyif  => 'test -f /data/peep-common.txt',
      require => [ File['/data/peep-common.txt'], Package['peep'] ];

    'install_prod_requirements':
      path    => '/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin',
      command => 'peep install -r /data/peep-prod.txt',
      onlyif  => 'test -f /data/peep-prod.txt',
      require => [ File['/data/peep-prod.txt'], Package['peep'] ];
  }

}
