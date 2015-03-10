Exec {
    logoutput => 'on_failure'
}

node default {
  
    # packer run_tags or ec2 instance tags
    if $ec2_tag_type == 'packer' {
        notify { "has the role packer": }
    }
    
    # packer puppet-masterless facter var(s)
    case $::packer_profile {
        'builder': {
            include treeherder::packages
            # ensure services off by default, too
        }

        default: {
            err("'${::packer_profile}' is not a valid Packer profile label.")
            fail('Invalid packer_profile.')
        }
    }
}
