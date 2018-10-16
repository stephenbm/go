#
# Cookbook:: go
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

directory node['go']['path']

template "#{ENV['HOME']}/.dotfiles/golang" do
  source 'golang.erb'
  mode 00644
  owner node['dotfiles']['user']
  group node['dotfiles']['group']
end

tar_path = "#{ENV['HOME']}/Downloads"
filename = "go#{node['go']['version']}.#{node['go']['os']}-#{node['go']['arch']}.tar.gz"

remote_file "#{tar_path}/#{filename}" do
  source "#{node['go']['repo']}/#{filename}"
  checksum node['go']['checksum']
  owner node['dotfiles']['user']
  group node['dotfiles']['group']
  notifies :run, 'execute[untar]', :delayed
end

execute "untar" do
  command "tar -C /usr/local -xzf #{filename} && chown -R root:wheel /usr/local/go"
  cwd tar_path
  action :nothing
end
