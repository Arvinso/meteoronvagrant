# Make sure the Apt package lists are up to date, so we're downloading versions that exist.
cookbook_file "apt-sources.list" do
  path "/etc/apt/sources.list"
end

execute 'apt_update' do
  command 'apt update'
end

# Base configuration recipe in Chef.
package "wget"
package "ntp"
package "nginx"
package "curl"

cookbook_file "ntp.conf" do
  path "/etc/ntp.conf"
end

execute 'ntp_restart' do
  command 'service ntp restart'
end

app_dir = "/home/ubuntu/project"

cookbook_file "nginx-default" do
  path "/etc/nginx/sites-available/default"
end

# PostgreSQL Packages
#apt_package %w(build-essential)
