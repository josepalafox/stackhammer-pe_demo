class pe_mcollective::role::agent (
  $mcollective_enable_stomp_ssl  = $pe_mcollective::params::mcollective_enable_stomp_ssl,
  $mcollective_psk_string        = $pe_mcollective::params::mcollective_psk_string,
  $mcollective_security_provider = $pe_mcollective::params::mcollective_security_provider,
  $stomp_password                = $pe_mcollective::params::stomp_password,
  $stomp_port                    = $pe_mcollective::params::stomp_port,
  $stomp_servers                 = $pe_mcollective::params::stomp_servers,
  $stomp_user                    = $pe_mcollective::params::stomp_user,
) inherits pe_mcollective::params {

  if ! $::is_pe {
    if ! $::warn_on_nonpe_agents {
      notify { 'pe_mcollective-un_supported_platform':
        message => $pe_mcollective::params::warn_nonpe_agent,
      }
    }
  } elsif $::osfamily == 'Windows' {
    # for PE Windows platforms, do nothing
  } else {
    class { 'pe_mcollective::server':
      mcollective_enable_stomp_ssl  => $mcollective_enable_stomp_ssl,
      mcollective_security_provider => $mcollective_security_provider,
      mcollective_psk_string        => $mcollective_psk_string,
      stomp_user                    => $stomp_user,
      stomp_password                => $stomp_password,
      stomp_servers                 => $stomp_servers,
      stomp_port                    => $stomp_port,
    }
  }

}
