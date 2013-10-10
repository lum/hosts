#
# Cookbook Name:: hosts
# Recipe:: default
# Author:: Steve Lum <steve.lum@gmail.com>
#
# Copyright 2013, Tempo
#

if !Chef::Config[:solo]
	hosts = search(:node, "chef_environment:#{node.chef_environment}")
else
  hosts = node['ipaddress']
end

template "/etc/hosts" do
  source "hosts.erb"
  owner "root"
  group "root"
  mode 0644
  variables(:hosts => hosts)
end

new_hostname = "#{node['name']}"
new_fqdn = "#{new_hostname}.#{node['cluster']}.tempo.ai"

execute "hostname --file /etc/hostname" do
  action :nothing
end

file "/etc/hostname" do
  content "#{node['name']}.#{node['cluster']}.tempo.ai"
  notifies :run, resources(:execute => "hostname --file /etc/hostname"), :immediately
  ignore_failure true
end

# update the node attributes during the chef run, so that the new values can be used later
node.automatic_attrs["hostname"] = new_hostname
node.automatic_attrs["fqdn"] = new_fqdn
