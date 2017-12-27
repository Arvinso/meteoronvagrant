# Make sure the Apt package lists are up to date, so we're downloading versions that exist.
cookbook_file "apt-sources.list" do
  path "/etc/apt/sources.list"
end

apt_repository 'mongodb-org-3.6' do
  uri 'https://repo.mongodb.org/apt/ubuntu'
  arch 'amd64'
  components ['multiverse']
  distribution 'xenial/mongodb-org/3.6'
  key '2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5'
  keyserver 'keyserver.ubuntu.com'
  action :add
end

execute 'apt_update' do
  command 'apt-get update'
end

# Base configuration recipe in Chef.
package "wget"
package "ntp"
package "curl"
cookbook_file "ntp.conf" do
  path "/etc/ntp.conf"
end
execute 'ntp_restart' do
  command 'service ntp restart'
end
app_dir = "/home/ubuntu/project"

# Project modifications
package "nginx"
package "mongodb-org"

# Specific mongodb install
# apt_package %w(mongodb-org=3.6.0 mongodb-org-server=3.6.0 mongodb-org-shell=3.6.0 mongodb-org-mongos=3.6.0 mongodb-org-tools=3.6.0)

cookbook_file "nginx-default" do
  path "/etc/nginx/sites-available/default"
end

# Install meteor
execute 'install_meteor' do
  command 'curl https://install.meteor.com/ | sh'
end

execute 'Create_meteor_project' do
  command 'meteor create simple-todos'
  cwd "/home/ubuntu/project"
  user "ubuntu"
end

service "mongod" do
  action :restart
end

service "nginx" do
  action :restart
end
