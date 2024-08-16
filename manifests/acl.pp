define bind::acl(
  Enum['present', 'absent'] $ensure = 'present',
  Array $acls                       = [],
) {

  $_ensure = $ensure? {
    'present' => 'file',
    default   => 'absent',
  }

  $_name = regsubst($name, '\s', '-', 'G')

  file {$name:
    ensure  => $_ensure,
    content => template('bind/acl.erb'),
    group   => 'root',
    mode    => '0640',
    notify  => Exec['reload bind9'],
    owner   => $bind::params::bind_group,
    path    => "${bind::params::acls_directory}/${_name}",
  }
  if $ensure == 'present' {
    concat::fragment {"acl.${_name}":
      content => "include \"${bind::params::acls_directory}/${_name}\";\n",
      notify  => Exec['reload bind9'],
      target  => "${bind::params::config_base_dir}/acls.conf",
    }
  }
}
