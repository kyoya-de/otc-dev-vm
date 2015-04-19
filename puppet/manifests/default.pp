node default {
  Exec { path => [ "/bin", "/sbin", "/usr/bin", "/usr/sbin", "/usr/local/bin", "/usr/local/sbin" ] }

  class { 'apt':
    always_apt_update    => false,
    apt_update_frequency => undef,
    disable_keys         => undef,
    proxy_host           => false,
    proxy_port           => '8080',
    purge_sources_list   => false,
    purge_sources_list_d => false,
    purge_preferences_d  => false,
    update_timeout       => undef,
    fancy_progress       => undef
  }

  apt::ppa { "ppa:ondrej/php5": }

  class { "apache":
    mpm_module    => "prefork",
    purge_configs => false,
    require       => [
      Exec["add-apt-repository-ppa:ondrej/php5"],
      Exec["apt_update"]
    ]
  }

  apache::mod { "rewrite": }

  file { "/srv/otc.local":
    ensure  => directory,
    owner   => vagrant,
    group   => www-data,
    require => Package["httpd"]
  }

  apache::vhost{ "otc.local":
    port     => 80,
    docroot  => '/srv/otc.local/web',
    docroot_group => "www-data",
    docroot_owner => "vagrant",
    options  => 'Indexes MultiViews FollowSymLinks',
    override => 'All',
    require  => [
      Exec["apt_update"],
      File["/srv/otc.local"]
    ]
  }

  class { "mysql::server":
    require => Exec["apt_update"]
  }

  class { "mysql::client":
    require => Exec["apt_update"]
  }

  package { ["php5", "php5-dev", "php5-recode", "php5-mysqlnd", "php5-common", "php5-xdebug", "php5-mcrypt", "php5-json", "php5-intl", "php5-imagick", "php5-gd", "php5-curl"]:
    ensure  => latest,
    notify  => Service["httpd"],
    require => [
      Package["httpd"],
      Exec["add-apt-repository-ppa:ondrej/php5"]
    ]
  }

  apache::mod { "php5":
    notify  => Service["httpd"],
    require => [
      Package["httpd"],
      Package["php5"]
    ]
  }

  file { "/etc/php5/mods-available/xdebug.ini":
    content => "zend_extension=xdebug.so
xdebug.cli_color=1
xdebug.max_nesting_level=500
xdebug.remote_enable=1
xdebug.remote_host=192.168.56.1
xdebug.var_display_max_children=512
xdebug.var_display_max_data=2560
xdebug.var_display_max_depth=200",
    notify  => Service["httpd"],
    require => Package["php5"]
  }

  file { "/etc/php5/mods-available/opcache.ini":
    content => "zend_extension=opcache.so
opcache.enable=1
opcache.cli_enable=1",
    notify  => Service["httpd"],
    require => Package["php5"]
  }

  file { "/etc/php5/mods-available/date.ini":
    content => "[Date]
date.timezone = Europe/Berlin",
    notify  => Service["httpd"],
    require => Package["php5"]
  }

  exec{ "php5enmod date":
    notify  => Service["httpd"],
    require => Package["php5"]
  }

  file { "/etc/bash_completion.d/bash_aliases.sh":
    ensure  => file,
    content => "alias ls='ls --color=auto'
alias dir='ls -al'
alias grep='grep --color=auto'"
  }

  exec { "a2enmod dir":
    notify  => Service["httpd"],
    require => Package["httpd"]
  }

  exec { "a2enmod php5":
    notify  => Service["httpd"],
    require => [
      Package["httpd"],
      Package["php5"]
    ]
  }

  exec { "usermod -g www-data -aG vagrant vagrant": }

  augeas { "set_umask":
    changes => [
      "set /files/etc/login.defs/UMASK 002"
    ]
  }
}
