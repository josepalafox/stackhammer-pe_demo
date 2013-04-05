class pe_mcollective::server (
  $mcollective_enable_stomp_ssl  = $pe_mcollective::params::mcollective_enable_stomp_ssl,
  $mcollective_psk_string        = $pe_mcollective::params::mcollective_psk_string,
  $mcollective_security_provider = $pe_mcollective::params::mcollective_security_provider,
  $stomp_password                = $pe_mcollective::params::stomp_password,
  $stomp_port                    = $pe_mcollective::params::stomp_port,
  $stomp_servers                 = $pe_mcollective::params::stomp_servers,
  $stomp_user                    = $pe_mcollective::params::stomp_user,
) inherits pe_mcollective::params {
  include pe_mcollective::server::plugins

  include pe_mcollective::shared_key_files
  File <| tag == 'pe_mco_server' |>

  if $::operatingsystem == 'solaris' {
    file_line { 'Solaris: pe-mcollective log rotation':
      line => '/var/log/pe-mcollective/mcollective.log -C 14 -c -p 1w',
      path => '/etc/logadm.conf',
    }
  }

  # Having this public key present is not desirable, it can lead to any
  # collective member having access to any collective node.
  file { '/etc/puppetlabs/mcollective/ssl/clients/mcollective-public.pem':
    ensure => absent,
  }

  # Manage the MCollective server configuration
  # Template uses:
  # - $puppetversion (fact)
  # - $operatingsystem (fact)
  # - $clientcert (top-scope variable)
  # - $mcollective_enable_stomp_ssl
  # - $mcollective_security_provider
  # - $mcollective_psk_string
  # - $stomp_user
  # - $stomp_password
  # - $stomp_servers
  # - $stomp_port
  file { '/etc/puppetlabs/mcollective/server.cfg':
    content => template("${module_name}/server.cfg.erb"),
    mode    => '0600',
    notify  => Service['pe-mcollective'],
  }
  service { 'pe-mcollective':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

  # Manage facter metadata updates for MCollective in PE.
  file { '/opt/puppet/sbin/refresh-mcollective-metadata':
    owner   => '0',
    group   => '0',
    mode    => '0755',
    content => template('pe_mcollective/refresh-mcollective-metadata'),
    before  => Cron['pe-mcollective-metadata'],
  }
  cron { 'pe-mcollective-metadata':
    command => '/opt/puppet/sbin/refresh-mcollective-metadata',
    user    => 'root',
    minute  => [ '0', '15', '30', '45' ],
  }

}
