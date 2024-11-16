# = Definition: bind::a
#
# Creates an IPv4 record.
#
# Arguments:
#  *$zone*:       Bind::Zone name
#  *zone_arpa*:   needed if you set $ptr to true
#  *$ptr*:        set it to true if you want the related PTR records
#                 NOTE: don't forget to create the zone!
#
#  For other arguments, please refer to bind::records !
#
define bind::a(
  String $zone,
  Hash $hash_data,
  Enum['present', 'absent'] $ensure = 'present',
  Optional[String] $zone_arpa        = undef,
  Boolean $ptr                       = true,
  $content                           = undef,
  $content_template                  = undef,
) {

  if ($ptr and !$zone_arpa) {
    fail 'You need zone_arpa if you want the PTR!'
  }

  bind::records {$name:
    ensure           => $ensure,
    zone             => $zone,
    hash_data        => $hash_data,
    record_type      => 'A',
    content          => $content,
  }

  if $ptr {
    bind::records {"PTR ${name}":
      ensure           => $ensure,
      zone             => $zone_arpa,
      record_type      => 'PTR',
      ptr_zone         => $zone,
      hash_data        => $hash_data,
      content          => $content,
    }
  }
}
