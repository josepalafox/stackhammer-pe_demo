# MCollective Puppet Enterprise
#
# This module manages the initial configuration of MCollective for use with
# Puppet Enterprise.  The primary purpose is to generate RSA key pairs for the
# initial "peadmin" user account on the Puppet Master and a shared set of RSA keys
# for all of the MCollective server processes (Puppet Agent roles).
#
# Resources managed on a Puppet Master:
#
#  * peadmin user account
#  * RSA keys to identify and authorize the peadmin user.
#  * One set of RSA keys generated for shared use among all MCollective agents.
#
# Resources managed on a Puppet Agent:
#
#  * RSA keys for MCollective service
#  * peadmin user account public RSA key to authenticate the peadmin user
#
# == Parameters
#
# This class expects four facts to be provided:
#
#  * fact_stomp_server    (hostname)
#  * fact_stomp_port      (TCP port number)
#
# The facts are automatically set by the Puppet Enterprise installer for each
# system.
#
# This class defaults to the "psk" security provider.  You may
# optionally specify the "aespe_security" security provider by setting the
# $::mcollective_security_provider variable in the Puppet Dashboard or as a
# custom fact.
#
# If a pre-shared-key is used, a randomly generated string (The contents of the
# mcollective credientials file) with be fed into the SHA1 hash algorithm to
# produce a unique key.
#
# T# (#9045) Update facter facts on disk periodically using a cron jobhis module will automatically setup up openwire network connectors for all
# brokers you indicate.  To do this you can either set an array using the
# parameters or from within the Console set activemq_brokers to a comma
# seperated list and the module with do the correct thing.
#
class pe_mcollective {
  include pe_mcollective::params

  if $pe_mcollective::params::is_pe and $::osfamily == 'Windows' {
    # Do nothing on windows
  } elsif $pe_mcollective::params::is_pe {
    # Assume that if this class was included directly the agent role is
    # intended. Note that legacy classification was based on facts and so only
    # this class was included and all other classification performed
    # dynamically.
    include pe_mcollective::role::agent
  } else {
    # Allow users to disable this notification
    if ! $::warn_on_nonpe_agents {
      notify { 'pe_mcollective-un_supported_platform':
        message => $pe_mcollective::params::warn_nonpe_agent,
      }
    }
  }

}
