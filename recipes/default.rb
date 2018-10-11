#
# Cookbook:: go
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

directory node['go']['path']

template "#{ENV['HOME']}/.dotfiles/golang" do
  source 'golang.erb'
  mode 00644
  owner node['dotfiles']['owner']
  group node['dotfiles']['group']
end

tar_path = "#{node['go']['path']}/tarballs"
filename = "go#{node['go']['version']}.#{node['go']['os']}-#{node['go']['arch']}.tar.gz"

directory "#{node['go']['path']}/tarballs" do
  owner node['dotfiles']['owner']
  group node['dotfiles']['group']
end

remote_file "#{tar_path}/#{filename}" do
  source "#{node['go']['repo']}/#{filename}"
  checksum node['go']['checksum']
  owner node['dotfiles']['owner']
  group node['dotfiles']['group']
  notifies :execute, 'execute[untar]', :delayed
end

execute "untar" do
  command "tar -C /usr/local -xzf #{filename}"
  user 'root'
  cwd tar_path
  action :nothing
end
