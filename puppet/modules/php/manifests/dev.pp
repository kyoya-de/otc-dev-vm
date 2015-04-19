# == Class: php::dev
#
# PHP dev package
#
# Install the development headers for PHP
#
# === Parameters
#
# [*ensure*]
#   The PHP ensure of PHP dev to install
#
# [*package*]
#   The package name for the PHP development files
#
# === Authors
#
# Christian "Jippi" Winther <jippignu@gmail.com>
# Robin Gloster <robin.gloster@mayflower.de>
#
# === Copyright
#
# See LICENSE file
#
class php::dev(
  $ensure  = $php::ensure,
  $package = "${php::package_prefix}${php::params::dev_package_suffix}",
) inherits php::params {


  if $caller_module_name != $module_name {
    warning('php::dev is private')
  }

  validate_string($ensure)
  validate_string($package)

  package { $package:
    ensure  => $ensure,
    require => Class['php::packages'],
  }
}
