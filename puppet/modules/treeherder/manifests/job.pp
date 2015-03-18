define treeherder::job (
  $cmd_path   = "${treeherder::app_root}/treeherder-service/bin",
  $jobuser    = "${treeherder::user}",
  $app_dir    = "${treeherder::app_root}",
  $stopsignal = 'TERM',
  $stopwaitsecs = '90',
) {
  # set autostart/autorestart based on ::enable?
  supervisord::program {
    "${name}":
      command        => "${cmd_path}/${name}",
      ensure         => "${treeherder::enable}",
      ensure_process => "${treeherder::ensure}",
      user           => "${jobuser}",
      directory      => "${app_dir}",
      stopsignal     => "${stopsignal}",
      stopwaitsecs   => "${stopwaitsecs}";
  }
}
