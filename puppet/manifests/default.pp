Exec {
    logoutput => 'on_failure'
}

node default {

  # must be a cleaner way...
  if $::ec2_tag_type != '' or $::ec2_tag_type == 'all' {
    $node_type = $::ec2_tag_type
  } else {
    $node_type = ['admin', 'etl', 'processor', 'rabbitmq', 'web']
  }

  # packer does the initial install
  if $::packer_profile == 'builder' {
    include treeherder::install
  } else {
    class {
      'treeherder':
        environ   => 'stage',
        node_type => $node_type
    }
  }
}
