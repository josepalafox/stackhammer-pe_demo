require 'spec_helper'

describe 'pe_mcollective' do
  before :all do
    @facter_facts = {
      'osfamily'              => 'RedHat',
      'lsbmajdistrelease'     => '6',
      'puppetversion'         => '2.7.19 (Puppet Enterprise 2.7.0)',
      'fact_is_puppetmaster'  => 'true',
      'fact_is_puppetconsole' => 'true',
      'fact_is_puppetagent'   => 'true',
      'fact_stomp_server'     => 'testagent',
      'fact_stomp_port'       => '9999',
      'is_pe'                 => 'true',
      'stomp_password'        => '0123456789abcdef',
    }
  end

  let :facts do
    @facter_facts
  end

  let :wrapper do
    '/etc/puppetlabs/activemq/activemq-wrapper.conf'
  end

  let :amq_xml do
    '/etc/puppetlabs/activemq/activemq.xml'
  end

  context "for a PE Windows agent" do
    let :facts do
      @facter_facts.merge({
        'osfamily' => 'Windows',
      })
    end
    it { should contain_class 'pe_mcollective' }
    it { should contain_class 'pe_mcollective::params' }
    it { should_not contain_class 'pe_mcollective::role::agent' }
  end

  context "for a non-PE agent (warn_on_nonpe_agents true or undef)" do
    let :facts do
      @facter_facts.merge({
        'is_pe'                => 'false',
        'warn_on_nonpe_agents' => :undef,
      })
    end
    it { should contain_class 'pe_mcollective' }
    it { should_not contain_class 'pe_mcollective::role::agent' }
    it { should contain_notify 'pe_mcollective-un_supported_platform' }
  end

  context "for a non-PE agent (warn_on_nonpe_agents true)" do
    let :facts do
      @facter_facts.merge({
        'is_pe'                => 'false',
        'warn_on_nonpe_agents' => 'true',
      })
    end
    it { should_not contain_notify 'pe_mcollective-un_supported_platform' }
  end

  context "for a PE agent" do
    let :facts do
      @facter_facts.merge({
        'osfamily' => 'RedHat',
      })
    end
    it { should contain_class 'pe_mcollective' }
    it { should contain_class 'pe_mcollective::role::agent' }
  end

end
