Exec {
    logoutput => 'on_failure'
}

node default {

  # only install if run by packer
  if $::packer_profile == 'builder' {
    include treeherder::install
  }

  # should use generic var, which can be then be set to type by ec2 tags or docker foo
  # use to set treeherder::node_type
  #class {
  #  'treeherder':
  #    environ   => 'staging',
  #    node_type => '',
  #}

  #case $::ec2_tag_type {
  #  'admin': {
  #    include treeherder::foo
  #  }
  #
  #  'etl': {
  #    include treeherder::foo
  #  }
  #
  #  'processor': {
  #    include treeherder::foo
  #  }
  #
  #  'rabbitmq': {
  #    include treeherder::foo
  #  }
  #
  #  'web': {
  #    include treeherder::foo
  #  }
  #
  #  default: {
  #    err("${::ec2_tag_type} is unknown or not a valid type.")
  #    fail('Invalid ec2_tag_type.')
  #  }
}
