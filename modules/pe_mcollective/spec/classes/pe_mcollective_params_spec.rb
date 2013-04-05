require 'spec_helper'

describe 'pe_mcollective::params' do
  before :all do
    @facter_facts = {
      'osfamily'              => 'RedHat',
      'lsbmajdistrelease'     => '6',
      'puppetversion'         => '2.7.19 (Puppet Enterprise 2.7.0)',
      'fact_is_puppetmaster'  => 'true',
      'fact_is_puppetconsole' => 'true',
      'fact_is_puppetagent'   => 'true',
      'fact_stomp_server'     => 'testagent',
      'fact_stomp_port'       => '6163',
      'is_pe'                 => 'true',
      'stomp_password'        => '0123456789abcdef',
    }
  end

  let :facts do
    @facter_facts
  end

  it "Should not contain any resources" do
    # The 4 are class[pe_mcollective::metadata], class[main], class[settings], stage[main]
    subject.resources.size.should == 4
  end
end
