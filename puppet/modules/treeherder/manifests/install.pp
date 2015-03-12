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

  # to be combined into one file for peep
  exec {
    'install_compiled_requirements':
      path    => '/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin',
      command => 'pip install -r /data/treeherder-service/requirements/compiled.txt',
      onlyif  => 'test -f /data/treeherder-service/requirements/compiled.txt',
      require => Exec['checkout_treeherder_service'];
  }

  exec {
    'install_pure_requirements':
      path    => '/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin',
      command => 'pip install -r /data/treeherder-service/requirements/pure.txt',
      onlyif  => 'test -f /data/treeherder-service/requirements/pure.txt',
      require => Exec['checkout_treeherder_service'];
  }

  exec {
    'install_prod_requirements':
      path    => '/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin',
      command => 'pip install -r /data/treeherder-service/requirements/prod.txt',
      onlyif  => 'test -f /data/treeherder-service/requirements/prod.txt',
      require => Exec['checkout_treeherder_service'];
  }

}
