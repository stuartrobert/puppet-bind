# = Definition: bind::record
#
# Helper to create any record you want (but NOT MX, please refer to Bind::Mx)
#
# Arguments:
#  *$zone*:             Bind::Zone name
#  *$record_type*:      Resource record type
#  *$ptr_zone*:         PTR zone - optional
#  *$content_template*: Allows you to do your own template, letting you
#                       use your own hash_data content structure
#  *$hash_data:         Hash containing data, by default in this form:
#        {
#          <host>         => {
#            owner        => <owner>,
#            ttl          => <TTL> (optional),
#            record_class => <Class>, (optional - default IN)
#          },
#          <host>         => {
#            owner        => <owner>,
#            ttl          => <TTL> (optional),
#            ptr          => false, (optional, default to true)
#            record_class => <Class>, (optional - default IN)
#          },
#          ...
#        }
#
define bind::records (
  String $zone,
  Hash $hash_data,
  String $record_type,
  Enum['present', 'absent'] $ensure  = 'present',
  $content                           = undef,
  Optional[String] $ptr_zone         = undef,
) {

  if ($content) {
    $record_content = $content
  } else {
    $record_content = epp('bind/records.epp')
  }

  if $ensure == 'present' {
    concat::fragment {"${zone}.${record_type}.${name}":
      target  => "${bind::params::pri_directory}/${zone}.conf",
      content => $record_content,
      order   => '10',
      notify  => Service['bind9'],
    }
  }
}
