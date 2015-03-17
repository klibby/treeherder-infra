Exec {
    logoutput => 'on_failure'
}

node default {

  # packer does the initial install
  if $::packer_profile == 'builder' {
    include treeherder::install
  }

  # must be a cleaner way...
  if $::ec2_tag_type != '' or $::ec2_tag_type == 'all' {
    $node_type = $::ec2_tag_type
  } else {
    $node_type = ['admin', 'etl', 'processor', 'rabbitmq', 'web']
  }

  class {
    'treeherder':
      environ   => 'stage',
      node_type => "$node_type"
  }

}
