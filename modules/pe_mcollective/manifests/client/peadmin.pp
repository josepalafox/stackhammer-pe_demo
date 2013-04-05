class pe_mcollective::client::peadmin (
  $mcollective_enable_stomp_ssl  = $pe_mcollective::params::mcollective_enable_stomp_ssl,
  $mcollective_psk_string        = $pe_mcollective::params::mcollective_psk_string,
  $mcollective_security_provider = $pe_mcollective::params::mcollective_security_provider,
  $stomp_password                = $pe_mcollective::params::stomp_password,
  $stomp_port                    = $pe_mcollective::params::stomp_port,
  $stomp_servers                 = $pe_mcollective::params::stomp_servers,
  $stomp_user                    = $pe_mcollective::params::stomp_user,
) inherits pe_mcollective::params {

  $peadmin_home      = '/var/lib/peadmin'
  $logfile           = "$peadmin_home/.mcollective.d/client.log"
  $private_cert_path = "$peadmin_home/.mcollective.d/peadmin-private.pem"
  $public_cert_path  = "$peadmin_home/.mcollective.d/peadmin-public.pem"

  File {
    ensure => file,
    owner  => 'peadmin',
    group  => 'peadmin',
    mode   => '0600',
  }

  pe_accounts::user { 'peadmin':
    ensure   => present,
    password => '!!',
    home     => $peadmin_home,
  }
  # Template uses:
  # - $puppetversion (fact)
  # - $mcollective_enable_stomp_ssl
  # - $mcollective_security_provider
  # - $mcollective_psk_string
  # - $stomp_user
  # - $stomp_password
  # - $stomp_servers
  # - $stomp_port
  # - $logfile
  # - $private_cert_path
  # - $public_cert_path
  file { "$peadmin_home/.mcollective":
    content => template('pe_mcollective/client.cfg.erb'),
    require => Pe_accounts::User['peadmin'],
  }
  file { '/etc/puppetlabs/mcollective/client.cfg':
    ensure  => absent,
  }
  file { "$peadmin_home/.mcollective.d":
    ensure  => directory,
    mode    => '0700',
    require => Pe_accounts::User['peadmin'],
  }
  file { "$peadmin_home/.mcollective.d/peadmin-private.pem":
    source  => '/etc/puppetlabs/puppet/ssl/private_keys/pe-internal-peadmin-mcollective-client.pem',
    require => [
      Pe_accounts::User['peadmin'],
      Pe_mcollective::Puppet_certificate['pe-internal-peadmin-mcollective-client'],
    ],
  }
  file { "$peadmin_home/.mcollective.d/peadmin-public.pem":
    source  => '/etc/puppetlabs/puppet/ssl/public_keys/pe-internal-peadmin-mcollective-client.pem',
    mode    => '0644',
    require => [
      Pe_accounts::User['peadmin'],
      Pe_mcollective::Puppet_certificate['pe-internal-peadmin-mcollective-client'],
    ],
  }
  file { "$peadmin_home/.mcollective.d/peadmin-cert.pem":
    source  => '/etc/puppetlabs/puppet/ssl/certs/pe-internal-peadmin-mcollective-client.pem',
    mode    => '0644',
    require => [
      Pe_accounts::User['peadmin'],
      Pe_mcollective::Puppet_certificate['pe-internal-peadmin-mcollective-client'],
    ],
  }
  # Because the accounts module is managing the .bashrc, we use
  # .bashrc.custom, which is included by default in the managed .bashrc
  # Template uses: $puppetversion (fact)
  file { "$peadmin_home/.bashrc.custom":
    ensure  => file,
    content => template("${module_name}/bashrc_custom.erb"),
    mode    => '0644',
    require => Pe_accounts::User['peadmin'],
  }
}
