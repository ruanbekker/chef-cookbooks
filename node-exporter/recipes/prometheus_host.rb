# environment 
env = node['envname']

# service array to loop through
services = ['node_exporter']

# create users
services.each do |username|
  user username do
    comment "#{username} service user"
    shell   "/bin/false"
  end
end

# fetch archives
services.each do |srv|
  remote_file "/tmp/#{node[srv]['arch']}.tar.gz" do
    source node[srv]['src']
  end
end

# stops service
services.each do |srv|
  service srv do
    action :stop
    ignore_failure true
  end
end

# extract archives
services.each do |srv|
  cfg = node[srv]
  execute "#{srv}-update" do
    command "tar -xf #{cfg['arch']}.tar.gz && cp #{cfg['arch']}/#{cfg['bins']} /usr/local/bin/"
    cwd 'tmp'
  end
end

# apply permissions
services.each do |srv|
  cookbook_file "/etc/systemd/system/#{srv}.service" do
    source "#{srv}.service"
    mode '0655'
  end
end

# reload systemd
execute 'daemon-reload' do
  command 'systemctl daemon-reload'
end

label_keys = %w(hostname)

# start services
services.each do |srv|
  service srv do
    action :start
  end
end

# get service status
services.each do |srv|
  execute "#{srv}-status" do
    command "systemctl status #{srv}.service"
  end
end
