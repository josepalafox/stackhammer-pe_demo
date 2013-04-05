class pe_mcollective::shared_key_files {
  # Configure the AES keys for each mcollective server (Note, these are not
  # actually used as SSL certificates, they're just used for their public and
  # private keys if AES security is enabled.)
  #
  # Note that all file resources declared here are virtual. They will be
  # realized in other pe_mcollective classes based on tags.

  File {
    ensure => file,
    owner  => '0',
    group  => '0',
    mode   => '0644',
  }

  # Common directories
  @file { '/etc/puppetlabs/mcollective/ssl':
    ensure => directory,
    mode   => '0755',
    notify => Service['pe-mcollective'],
    tag    => ['pe_mco_server'],
  }
  @file { '/etc/puppetlabs/mcollective/ssl/clients':
    ensure => directory,
    mode   => '0755',
    tag    => ['pe_mco_server'],
  }

  # MCollective server key files
  @file { 'mcollective-public.pem':
    path    => '/etc/puppetlabs/mcollective/ssl/mcollective-public.pem',
    content => file('/etc/puppetlabs/puppet/ssl/public_keys/pe-internal-mcollective-servers.pem', '/dev/null'),
    notify  => Service['pe-mcollective'],
    tag     => ['pe_mco_server'],
  }
  @file { 'mcollective-private.pem':
    path    => '/etc/puppetlabs/mcollective/ssl/mcollective-private.pem',
    content => file('/etc/puppetlabs/puppet/ssl/private_keys/pe-internal-mcollective-servers.pem', '/dev/null'),
    mode    => '0600',
    notify  => Service['pe-mcollective'],
    tag     => ['pe_mco_server'],
  }
  @file { 'mcollective-cert.pem':
    path    => '/etc/puppetlabs/mcollective/ssl/mcollective-cert.pem',
    content => file('/etc/puppetlabs/puppet/ssl/certs/pe-internal-mcollective-servers.pem', '/dev/null'),
    notify  => Service['pe-mcollective'],
    tag     => ['pe_mco_server'],
  }

  # Public key files for pe_mcollective clients (peadmin, puppet-dashboard)
  @file { 'peadmin-public.pem':
    path    => '/etc/puppetlabs/mcollective/ssl/clients/peadmin-public.pem',
    content => file('/etc/puppetlabs/puppet/ssl/public_keys/pe-internal-peadmin-mcollective-client.pem', '/dev/null'),
    notify  => Service['pe-mcollective'],
    tag     => ['pe_mco_server'],
  }
  @file { 'puppet-dashboard-public.pem':
    path    => '/etc/puppetlabs/mcollective/ssl/clients/puppet-dashboard-public.pem',
    content => file('/etc/puppetlabs/puppet/ssl/public_keys/pe-internal-puppet-console-mcollective-client.pem', '/dev/null'),
    notify  => Service['pe-mcollective'],
    tag     => ['pe_mco_server'],
  }

  # PE Console key files (for the puppet-dashboard mcollective client)
  @file { '/opt/puppet/share/puppet-dashboard/.mcollective.d/puppet-dashboard-private.pem':
    ensure  => file,
    content => file('/etc/puppetlabs/puppet/ssl/private_keys/pe-internal-puppet-console-mcollective-client.pem', '/dev/null'),
    owner   => 'puppet-dashboard',
    group   => 'puppet-dashboard',
    mode    => '0600',
    tag     => ['pe_mco_client_puppet_dashboard'],
  }
  @file { '/opt/puppet/share/puppet-dashboard/.mcollective.d/puppet-dashboard-public.pem':
    ensure  => file,
    content => file('/etc/puppetlabs/puppet/ssl/public_keys/pe-internal-puppet-console-mcollective-client.pem', '/dev/null'),
    owner   => 'puppet-dashboard',
    group   => 'puppet-dashboard',
    tag     => ['pe_mco_client_puppet_dashboard'],
  }
  @file { '/opt/puppet/share/puppet-dashboard/.mcollective.d/puppet-dashboard-cert.pem':
    ensure  => file,
    content => file('/etc/puppetlabs/puppet/ssl/certs/pe-internal-puppet-console-mcollective-client.pem', '/dev/null'),
    owner   => 'puppet-dashboard',
    group   => 'puppet-dashboard',
    tag     => ['pe_mco_client_puppet_dashboard'],
  }
}
