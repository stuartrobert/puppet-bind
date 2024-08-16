define bind::view(
  Enum['present', 'absent'] $ensure = 'present',
  Hash $options = {
    'recursion' => 'no',
  },
  Integer $order  = 10,
) {

  $_ensure = $ensure? {
    'present' => 'file',
    default   => $ensure,
  }

  $_name = regsubst($name, '\s', '-', 'G')

  file {"${bind::params::views_directory}/${_name}.view":
    ensure  => $_ensure,
    content => template('bind/view.erb'),
    group   => 'root',
    mode    => '0644',
    owner   => 'root',
  }

  concat {"${bind::params::views_directory}/${_name}.zones":
    ensure => $ensure,
    force  => true,
    group  => 'root',
    mode   => '0644',
    owner  => 'root',
  }

  if $ensure == 'present' {
    concat::fragment {"named.local.view.${_name}":
      target  => "${bind::params::config_base_dir}/${bind::params::named_local_name}",
      content => "include \"${bind::params::views_directory}/${_name}.view\";\n",
      order   => $order,
      notify  => Exec['reload bind9'],
      require => Class['bind::install'],
    }
  }
}
