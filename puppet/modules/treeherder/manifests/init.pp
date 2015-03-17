class treeherder (
  $environ   = 'default',
  $node_type,
  $enable    = $treeherder::params::enable,
  $ensure    = $treeherder::params::ensure,
  $domain    = $treeherder::params::domain,
  $app_root  = $treeherder::params::app_root,
  $user      = $treeherder::params::user,
  $group     = $treeherder::params::group,
) inherits treeherder::params {

  # how does this affect services, etc in ::install?
  #require treeherder::install

  validate_array($node_type)
  if ! ($node_type in [ 'admin', 'web', 'etl', 'rabbitmq', 'flower', 'processor' ]) {
    fail("\"${node_type}\" is not a valid node_type value.")
  }

  # newrelic

  if member($node_type, 'admin') {
    class { 'treeherder::admin': }
  }
  if member($node_type, 'etl') {
    class { 'treeherder::etl': }
  }
  if member($node_type, 'flower') {
    class { 'treeherder::flower': }
  }
  if member($node_type, 'processor') {
    class { 'treeherder::processor': }
  }
  if member($node_type, 'rabbitmq') {
    class { 'treeherder::rabbit': }
  }
  if member($node_type, 'web') {
    class { 'treeherder::web': }
  }

}
