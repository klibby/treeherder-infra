define treeherder::job (
  $enable     = "${treeherder::enable}",
  $ensure     = "${treeherder::ensure}",
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
      ensure         => "${ensure}",
      ensure_process => "${enable}",
      user           => "${jobuser}",
      directory      => "${app_dir}",
      stopsignal     => "${stopsignal}",
      stopwaitsecs   => "${stopwaitsecs}";
  }
}
