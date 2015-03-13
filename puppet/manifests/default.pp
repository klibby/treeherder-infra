Exec {
    logoutput => 'on_failure'
}

node default {
  
    # packer puppet-masterless facter var(s)
    case $::packer_profile {
        'builder': {
            include treeherder::install
            # ensure services off by default, too
        }

        default: {
            err("'${::packer_profile}' is not a valid Packer profile label.")
            fail('Invalid packer_profile.')
        }
    }
}
