class treeherder::rabbit {
  notify { 'debug_rabbit':
    message => "loading class rabbit"
  }

  # need to add SSL
  # how to handle multiple cluster nodes?
  class {
    '::rabbitmq':
      manage_repos      => false,
      service_ensure    => "${treeherder::enable}",
      config_cluster    => true,
      cluster_nodes     => ['localhost'],
      cluster_node_type => 'disk',
      erlang_cookie     => 'ERLANG-rabbit-cookie',
  }

  rabbitmq_user {
    'admin':
      admin    => true,
      password => 'pw';

    'treeherder':
      admin    => false,
      password => 'pw';
  }

  rabbitmq_vhost {
    '/':
      ensure => present;

    'treeherder':
      ensure => present;
  }

  rabbitmq_user_permissions {
    'treeherder@treeherder':
      configure_permission => '.*',
      read_permission      => '.*',
      write_permission     => '.*';
  }
}
