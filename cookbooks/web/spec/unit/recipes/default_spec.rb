#
# Cookbook:: mynginx
# Spec:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

#require 'spec_helper'
#
#describe 'mynginx::default' do
 # context 'When all attributes are default, on an Ubuntu 16.04' do
 #   let(:chef_run) do
 #     # for a complete list of available platforms and versions see:
 #     # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
 #     runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
 #     runner.converge(described_recipe)
 #   end
#
#   it 'converges successfully' do
#      expect { chef_run }.to_not raise_error
#    end
#  end
#end


require 'spec_helper'

describe 'web::default' do
  let(:chef_run) do
    runner =  ChefSpec::SoloRunner.new(platform: 'centos', version: '7.4.1708')
    runner.converge(described_recipe)
  end

  it 'Converges successfully' do
    expect { chef_run }.to_not raise_error
  end

  it 'Install nginx' do
    expect(chef_run).to install_package 'nginx'
  end

  it 'Ensure that nginx started' do
    expect(chef_run).to start_service('nginx')
  end

  it 'Ensure that web_server attach' do
    expect(chef_run).to attach_web_server 'serv'
  end

  it 'Ensure that web_server detach exists' do
    expect(chef_run).to detach_web_server 'also'
  end

  it 'Ensure that web_server  attach asd exists' do
    expect(chef_run).to_not attach_web_server 'asd'
  end
end
