class treeherder::web {
  notify { 'debug_web':
    message => "loading class web"
  }

  $apache_dev = $operatingsystem ? {
    ubuntu  => "apache2-dev",
    default => "httpd-devel"
  }
  $vhost_path = $operatingsystem ? {
    ubuntu  => "/etc/apache2/sites-enabled",
    default => "/etc/httpd/conf.d"
  }
  $apache_service = $operatingsystem ? {
    ubuntu  => "apache2",
    default => "httpd"
  }
  $port_file = $operatingsystem ? {
    ubuntu  => "/etc/apache2/ports.conf",
    default => "/etc/httpd/conf/httpd.conf"
  }

  # installed by packer in treeherder::install
  package {
    "$apache_service":
      ensure => present;
    "$apache_dev":
      ensure => present;
  }

  file {
    "${vhost_path}/treeherder-service.conf":
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => Package["${apache_dev}"],
      notify  => Service["${apache_service}"],
      content => template("${module_name}/httpd/treeherder-service.conf")
  }
  
  file {
    '/var/www/robots.txt':
      ensure => present,
      source => "puppet:///modules/${module_name}/robots.txt";
  }

  exec {
    'set_http_listen_port':
      path    => '/bin:/usr/bin:/sbin:/usr/sbin',
      command => "sed -i '/[: ]80$/ s/80/8080/' ${port_file}",
      require => Package["${apache_dev}"],
      before  => Service["${apache_service}"];
  }

  treeherder::job {
    'run_gunicorn':
        enable => "${treeherder::enable}",
        ensure => "${treeherder::ensure}";
  }

  service {
    "$apache_service":
      ensure  => "${treeherder::ensure}",
      enable  => "${treeherder::enable}",
      require => File["${vhost_path}/treeherder-service.conf"];
  }


  # by default ubuntu doesn't have these modules enabled
  if $operatingsystem == 'ubuntu'{
    exec {
      'a2enmod_rewrite':
        path    => '/bin:/usr/bin:/sbin:/usr/sbin',
        command => 'a2enmod rewrite',
        onlyif  => 'test ! -e /etc/apache2/mods-enabled/rewrite.load',
        before  => Service["${apache_service}"];
      'a2enmod_proxy':
        path    => '/bin:/usr/bin:/sbin:/usr/sbin',
        command => 'a2enmod proxy',
        onlyif  => 'test ! -e /etc/apache2/mods-enabled/proxy.load',
        before  => Service["${apache_service}"];
      'a2enmod_proxy_http':
        path    => '/bin:/usr/bin:/sbin:/usr/sbin',
        command => 'a2enmod proxy_http',
        onlyif  => 'test ! -e /etc/apache2/mods-enabled/proxy_http.load',
        before  => Service["${apache_service}"];
    }
  }
}
