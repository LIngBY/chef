#
# Cookbook:: mynginx
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
package 'nginx' do
  action :install
end

service 'nginx' do
  action [ :enable, :start ]
end


web_server 'serv' do
  action [:attach]
end

web_server 'also' do
  del_server '2.2.2.2'
  action [:detach]
end
