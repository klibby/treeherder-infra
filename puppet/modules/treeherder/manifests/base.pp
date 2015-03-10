class treeherder::base {
 
    # services off by default
    #    service {
    #    'apache2':
    #        ensure  => stopped,
    #        enable  => false,
    #        require => Package['apache2'];
    #
    #    'rabbitmq-server':
    #        ensure  => stopped,
    #        enable  => false,
    #        require => Package['rabbitmq-server'];
    #}

    package {
      [
        'python2.7',
        'python2.7-dev',
        'libpython2.7',
        'python-setuptools',
        'mysql-client',
        'mysql-common',
        'make',
        #        'apache2',
        #'rabbitmq-server',
        ]:
          ensure => latest;
    }
}
