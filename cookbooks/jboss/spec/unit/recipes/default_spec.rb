#
# Cookbook:: jboss
# Spec:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

#require 'spec_helper'

#describe 'jboss::default' do
#  context 'When all attributes are default, on an Ubuntu 16.04' do
#    let(:chef_run) do
#      # for a complete list of available platforms and versions see:
#      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
#      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
#      runner.converge(described_recipe)
#    end
#
#    it 'converges successfully' do
#      expect { chef_run }.to_not raise_error
#    end
#  end
#end


require 'chefspec'
require 'chefspec/berkshelf'

describe 'jboss::default' do
  let(:chef_run)do
    runner =  ChefSpec::SoloRunner.new(platform: 'centos', version: '7.4.1708')
    runner.converge(described_recipe) 
  end

  before do
    stub_data_bag_item("confeg", "jb_port").and_return("id": "ppport", "port": "8095")
  end

  it 'Converges successfully' do
    expect { chef_run }.to_not raise_error
  end

  it 'Create a template "server.xml"' do
    expect(chef_run).to create_template('/opt/jboss/server/default/deploy/jbossweb.sar/server.xml').with(
      source: 'server.xml.erb',
      user: 'jboss',
      group: 'jboss',
     # mode: '420',
    )
  end

  it 'Creates a systemd script "jboss"' do
    expect(chef_run).to create_systemd_unit('jboss.service')
  end
  
  it 'Creates user' do
    expect(chef_run).to create_user('jboss')
  end
end
