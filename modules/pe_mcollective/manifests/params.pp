class pe_mcollective::params {

  validate_re($::fact_stomp_server, '^[a-zA-Z0-9.-]+(,[a-zA-Z0-9.-]+)*$', join([
    "The fact named fact_stomp_server does not appear to be a valid hostname.",
    "The value of '${::fact_stomp_server}' does not match '^[a-zA-Z0-9.-]+$'.",
    "A common cause of this problem is running puppet agent as a normal user",
    "instead of root, or the fact is missing from",
    "/etc/puppetlabs/facter/facts.d/puppet_installer.txt. This fact is",
    "required. This UUID should help Google find this error:",
    "CA149CCB-0F9E-4208-BC29-18E3AF07CADF"
  ], ' '))

  validate_re($::fact_stomp_port, '^[0-9]+$', join([
    "The fact named fact_stomp_port is not numeric. It is currently set to:",
    "[${::fact_stomp_port}]. A common cause of this problem is running",
    "puppet agent as a normal user instead of root or the facts missing from",
    "/etc/puppetlabs/facter/facts.d/puppet_installer.txt. This fact is",
    "required. This UUID should help Google find this error:",
    "72F6395D-6FB3-4970-8300-3BC6149ECA08",
  ], ' '))

  # Warning printed on non-pe agents when pe_mcollective classification is
  # issued to them
  $warn_nonpe_agent = join([
    "${::clientcert} (osfamily = ${::osfamily}) is not a Puppet Enterprise",
    "agent. It will not appear when using the mco command-line tool or from",
    "within Live Management in the Puppet Enterprise Console. \n You may",
    "voice your opinion on PE platform support here:",
    "http://links.puppetlabs.com/puppet_enterprise_2.x_platform_support \n If",
    "you no longer wish to see this message for all non-PE agents, visit your",
    "Puppet Enterprise Console and create the parameter warn_on_nonpe_agents",
    "(key) to false (value) in the default group.",
  ], ' ')

  $fail_nonpe_agent = join([
    "${::clientcert} (osfamily = ${::osfamily}) is not a Puppet Enterprise",
    "agent. Non-PE nodes may not be classified with pe_mcollective roles. \n",
    "You may voice your opinion on PE platform support here:",
    "http://links.puppetlabs.com/puppet_enterprise_2.x_platform_support \n If",
    "you no longer wish to see this message for all non-PE agents, visit your",
    "Puppet Enterprise Console and create the parameter warn_on_nonpe_agents",
    "(key) to false (value) in the default group.",
  ], ' ')

  # #10961 This variable is used by the activemq-wrapper.conf template to set
  # the initial and maximum java heap size.  The value is looked up in the
  # class parameter, then the global scope so it may be set as a Fact or Node
  # Parameter.
  $activemq_heap_mb = $::activemq_heap_mb ? {
    undef   => '512',
    default => $::activemq_heap_mb,
  }

  # #12210 Sets up openwire connectors for replicating messages across all
  # brokers.  The class parameter takes precedence over the topscope variable.
  $activemq_brokers = split($::activemq_brokers, ',')

  # Stomp SSL Support
  # Turned on by default.
  $mcollective_enable_stomp_ssl = $::mcollective_enable_stomp_ssl ? {
    'true'  => true,
    'false' => false,
    undef   => true,
    ''      => true,
    default => $::mcollective_enable_stomp_ssl,
  }

  $stomp_servers = $::fact_stomp_server ? {
    undef   => $::server,
    default => split($::fact_stomp_server,','),
  }
  $stomp_port = $::fact_stomp_port ? {
    undef   => '61613',
    default => $::fact_stomp_port,
  }

  # Variables used by ERB templates.  This may be dynamically generated in the future.
  $stomp_user     = 'mcollective'
  # Editors leave trailing newlines.
  $stomp_password = $::stomp_password ? {
    undef   => chomp(file('/etc/puppetlabs/mcollective/credentials')),
    default => $::stomp_password,
  }

  # Pre-Shared Key for MCollective
  $mcollective_psk_string        = sha1("${stomp_password}\n")
  $mcollective_security_provider = $::mcollective_security_provider ? {
    undef   => 'psk',
    default => $::mcollective_security_provider,
  }

  # $::is_pe is a custom fact shipped with the stdlib module
  $is_pe = str2bool($::is_pe)
}
