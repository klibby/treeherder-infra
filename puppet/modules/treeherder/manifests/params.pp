class treeherder::params {
  # controls managed resources; present/absent
  $ensure    = 'present'
  # controls status of services: running/stopped
  $enable    = 'stopped'
  $domain    = 'localhost'
  $app_root  = '/data'
  $user      = 'treeherder'
  $group     = 'treeherder'
  #$rabbitmq_host
  #$rabbitmq_cluster_nodes
  #$rabbitmq_user
  #$rabbitmq_pass
  #$rabbitmq_vhost
  #$erlang_cookie
  #$db_name
  #$db_rw_host
  #$db_rw_user
  #$db_rw_pass
  #$db_ro_host
  #$db_ro_user
  #$db_ro_pass
  #$web_nodes
  #$django_secret
  #$pulse_user
  #$pulse_pass
}
