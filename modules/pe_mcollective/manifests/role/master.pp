class pe_mcollective::role::master (
  $activemq_brokers              = $pe_mcollective::params::activemq_brokers,
  $activemq_heap_mb              = $pe_mcollective::params::activemq_heap_mb,
  $mcollective_enable_stomp_ssl  = $pe_mcollective::params::mcollective_enable_stomp_ssl,
  $mcollective_psk_string        = $pe_mcollective::params::mcollective_psk_string,
  $mcollective_security_provider = $pe_mcollective::params::mcollective_security_provider,
  $stomp_password                = $pe_mcollective::params::stomp_password,
  $stomp_port                    = $pe_mcollective::params::stomp_port,
  $stomp_servers                 = $pe_mcollective::params::stomp_servers,
  $stomp_user                    = $pe_mcollective::params::stomp_user,
) inherits pe_mcollective::params {

  if ! $is_pe {
    fail($pe_mcollective::params::fail_nonpe_agent)
  }
  if $::osfamily == 'Windows' {
    fail("The pe_mcollective puppetmaster role cannot be applied on ${::osfamily}")
  }

  validate_re($activemq_heap_mb, '^[0-9]+$', join([
    "The activemq_heap_mb parameter must be a number, e.g. 1024.  We got:",
    "[${activemq_heap_mb}]",
  ], ' '))

  validate_bool($mcollective_enable_stomp_ssl)

  # We only support two security providers for the time being.
  validate_re($mcollective_security_provider, '^psk$|^aespe_security$', join([
    "The mcollective_security_provider parameter must be 'psk' or",
    "'aespe_security'. We got: [$mcollective_security_provider]",
  ], ' '))

  class { 'pe_mcollective::ca':
    mcollective_enable_stomp_ssl => $mcollective_enable_stomp_ssl,
    stomp_servers                => $stomp_servers,
  }
  class { 'pe_mcollective::activemq':
    activemq_brokers             => $activemq_brokers,
    activemq_heap_mb             => $activemq_heap_mb,
    mcollective_enable_stomp_ssl => $mcollective_enable_stomp_ssl,
    stomp_user                   => $stomp_user,
    stomp_password               => $stomp_password,
    stomp_port                   => $stomp_port,
  }
  class { 'pe_mcollective::client::peadmin':
    mcollective_enable_stomp_ssl  => $mcollective_enable_stomp_ssl,
    mcollective_security_provider => $mcollective_security_provider,
    mcollective_psk_string        => $mcollective_psk_string,
    stomp_user                    => $stomp_user,
    stomp_password                => $stomp_password,
    stomp_servers                 => $stomp_servers,
    stomp_port                    => $stomp_port,
  }

}
