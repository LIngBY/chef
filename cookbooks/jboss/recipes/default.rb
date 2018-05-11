#
# Cookbook:: jboss
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
#

include_recipe 'java'
package 'unzip'

# creating jboss user
user 'jboss' do
  #comment 'user for jboss service'
  uid '1111'
  shell '/bin/bash'
end

# downloading jboss archive
remote_file './jboss.zip' do
  source 'https://kent.dl.sourceforge.net/project/jboss/JBoss/JBoss-5.1.0.GA/jboss-5.1.0.GA.zip'
  # source 'http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.zip'
  show_progress true
end

# extracting archive to opt folder
bash 'unarchive' do
  code <<-EOH
    mkdir -p /opt/jboss
    unzip jboss.zip -d /opt
    cp -r /opt/jboss-5.1.0.GA/* /opt/jboss/
    chown -R jboss:jboss /opt/jboss
    EOH
end

# creating jboss service
systemd_unit 'jboss.service' do
  content <<-EOU
  [Unit]
  Description=Jboss Application Server
  After=network.target

  [Service]
  Type=forking

  User=jboss
  Group=jboss
  ExecStart=/bin/bash -c 'nohup /opt/jboss/bin/run.sh -b  #{node[:network][:interfaces][:enp0s8][:addresses].detect{|k,v| v[:family] == "inet" }.first} &'
  ExecStop=/bin/bash -c 'bin/shutdown.sh -s #{node[:network][:interfaces][:enp0s8][:addresses].detect{|k,v| v[:family] == "inet" }.first} -u admin'
  TimeoutStartSec=300
  TimeoutStopSec=600
  SuccessExitStatus=143

  [Install]
  WantedBy=multi-user.target
  EOU
  action [ :create, :enable, :start]
end


#server.xml copy from templates
data = data_bag_item('confeg','jb_port')
template '/opt/jboss/server/default/deploy/jbossweb.sar/server.xml' do
  source "server.xml.erb"
  owner 'jboss'
  group 'jboss'
  variables( ppport: data['port'])
  mode 0644
end


#sample application deploy
remote_file '/opt/jboss/server/default/deploy/sample.war' do
 # source 'https://tomcat.apache.org/tomcat-7.0-doc/appdev/sample/sample.war'
  source "#{node['war_link']}"
end
 

service 'jboss' do
  action :restart
end


