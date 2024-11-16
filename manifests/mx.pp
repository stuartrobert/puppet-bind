# = Definition: bind::mx
# Creates an MX record.
#
# Arguments:
#  *$zone*:     Bind::Zone name
#  *$owner*:    owner of the Resource Record
#  *$priority*: MX record priority
#  *$host*:     target of the Resource Record
#  *$ttl*:      Time to Live for the Resource Record. Optional.
#
define bind::mx (
  String $zone,
  String $host,
  String $priority,
  Enum['present', 'absent'] $ensure = 'present',
  Optional[String] $owner           = undef,
  Optional[String] $ttl             = undef,
) {

  $_owner = $owner ? {
    ''      => $name,
    default => $owner
  }

  if $ensure == 'present' {
    concat::fragment {"bind.${name}":
      target  => "${bind::params::pri_directory}/${zone}.conf",
      content => epp('bind/mx-record.epp'),
      notify  => Service['bind9'],
    }
  }
}

