Exec {
    logoutput => 'on_failure'
}

node default {
  
    # packer run_tags or ec2 instance tags
    if $ec2_tag_type == 'packer' {
        notify { "has the role packer": }
    }
    
    include treeherder::base

    # packer puppet-masterless facter var(s)
    case $::packer_profile {
        'worker': {
            include treeherder::worker
        }

        'webhead': {
            include treeherder::webhead
        }

        'rabbit': {
            include treeherder::rabbit
        }

        default: {
            err("'${::packer_profile}' is not a valid Packer profile label.")
            fail('Invalid packer_profile.')
        }
    }
}
