# == php::config::setting
#
# Configure php.ini settings
#
# === Parameters
#
# [*file*]
#   The path to ini file
#
# [*value*]
#   The value to set
#
# === Examples
#
# php::config::setting { 'Date/date.timezone':
#   file  => '$full_path_to_ini_file'
#   value => 'Europe/Berlin'
# }
#
# === Authors
#
# Robin Gloster <robin.gloster@mayflower.de>
#
# === Copyright
#
# See LICENSE file
#
define php::config::setting(
  $key,
  $value,
  $file,
) {

  if $caller_module_name != $module_name {
    warning('php::config::setting is private')
  }

  validate_string($file)

  $split_name = split($key, '/')
  if count($split_name) == 1 {
    $section = ''
    $setting = $split_name[0]
  } else {
    $section = $split_name[0]
    $setting = $split_name[1]
  }

  ini_setting { $name:
    value   => $value,
    path    => $file,
    section => $section,
    setting => $setting
  }
}
