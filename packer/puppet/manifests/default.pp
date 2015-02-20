Exec {
    logoutput => 'on_failure'
}

node default {
    
    include treeherder::base

    # packer_profile fact is build (e.g. ami) specific rather than
    # app specific (i.e. etl vs log processor, both of which are workers)
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
