property :role, String, default: 'app_server'
property :del_server, String, default: '1.2.3.4'

action :attach do
  result = ""
  search(:node, 'role:app_server').each do |node|
    p node['ipaddress']
    result += "server #{node['network']['interfaces']['enp0s8']['addresses'].detect{|k,v| v['family'] == 'inet' }.first}:8095; "
  end

  ip = node['network']['interfaces']['enp0s8']['addresses'].detect{|k,v| v['family'] == 'inet' }.first
  template '/etc/nginx/nginx.conf' do
    source "nginx.conf.erb"
    variables( server_list: result,
               nginx_server: ip)
  end

  service 'nginx' do
    action [:restart]
  end
end

action :detach do
#  file '/opt/file.rb' do
#    content del_server
#  end	
  #ruby_block 'delete line' do
  #  block do
  #    lines = File.readlines('/etc/nginx/nginx.conf')
  #    out_lines = lines.select {|line| !line.include? del_server} 
  #    File.open('/etc/nginx/nginx.conf','w') do |f|
  #      out_lines.each do |line|
  #        f.write line
  #      end
  #    end
#
#    end
#  end
  bash 'del' do
    code <<-EOH
      sed -i '/#{del_server}/d' /etc/nginx/nginx.conf
      EOH
  end
  service 'nginx' do
    action [:restart]
  end
end
