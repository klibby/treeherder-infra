define treeherder::job (
  $cmd_path   = "${treeherder::app_root}/treeherder-service/bin",
  $jobuser    = "${treeherder::user}",
  $app_dir    = "${treeherder::app_root}",
  $stopsignal = 'TERM',
  $stopwaitsecs = '90',
) {
  # set autostart/autorestart based on ::enable?
  # ensure/ensure_process = [ 'running', 'stopped', 'removed' ]
  supervisord::program {
    "${name}":
      command        => "${cmd_path}/${name}",
      #ensure         => "${treeherder::ensure}",
      #ensure_process => "${treeherder::enable}",
      user           => "${jobuser}",
      directory      => "${app_dir}",
      stopsignal     => "${stopsignal}",
      stopwaitsecs   => "${stopwaitsecs}";
  }
}
