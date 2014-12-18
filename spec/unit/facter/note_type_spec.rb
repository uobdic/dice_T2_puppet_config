require 'spec_helper'
require 'puppetlabs_spec_helper/puppetlabs_spec/puppet_internals'
require 'facter/node_type'

describe 'Facter::Util::Fact' do
  before { Facter.clear }
  after { Facter.clear }

  describe 'host' do
    it 'dice-vm-37-00.acrc.bris.ac.uk' do
      Facter.fact(:fqdn).stubs(:value).returns('dice-vm-37-00.acrc.bris.ac.uk')
      Facter.fact(:node_type).value.should == 'vm-host'
    end
    it 'vm-hep.dice.priv' do
      Facter.fact(:fqdn).stubs(:value).returns('vm-hep.dice.priv')
      Facter.fact(:node_type).value.should == 'vm-guest'
    end
    it 'lcgce01.phy.bris.ac.uk' do
      Facter.fact(:fqdn).stubs(:value).returns('lcgce01.phy.bris.ac.uk')
      Facter.fact(:node_type).value.should == 'lcg-node'
    end
    it 'hyperion.phy.bris.ac.uk' do
      Facter.fact(:fqdn).stubs(:value).returns('hyperion.phy.bris.ac.uk')
      Facter.fact(:node_type).value.should == 'unknown'
    end
    it 'dice-io-37-00.acrc.bris.ac.uk' do
      Facter.fact(:fqdn).stubs(:value).returns('dice-io-37-00.acrc.bris.ac.uk')
      Facter.fact(:node_type).value.should == 'io-node'
    end
    it 'lcgce01.phy.bris.ac.uk' do
      Facter.fact(:fqdn).stubs(:value).returns('lcgce01.phy.bris.ac.uk')
      Facter.fact(:node_type).value.should == 'lcg-node'
    end
    it 'nn-37-00.dice.priv' do
      Facter.fact(:fqdn).stubs(:value).returns('nn-37-00.dice.priv')
      Facter.fact(:node_type).value.should == 'headnode'
    end
    it 'jt-37-00.dice.priv' do
      Facter.fact(:fqdn).stubs(:value).returns('jt-37-00.dice.priv')
      Facter.fact(:node_type).value.should == 'headnode'
    end
    it 'hd-37-00.dice.priv' do
      Facter.fact(:fqdn).stubs(:value).returns('hd-37-00.dice.priv')
      Facter.fact(:node_type).value.should == 'worker'
    end
    it 'bc-37-00.dice.priv' do
      Facter.fact(:fqdn).stubs(:value).returns('bc-37-00.dice.priv')
      Facter.fact(:node_type).value.should == 'couchdb-node'
    end
  end
end
