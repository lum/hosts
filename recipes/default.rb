#
# Cookbook Name:: hosts
# Recipe:: client
#
# Copyright 2013, Tempo
#
#

template "/etc/hosts" do
  source "hosts.erb"
  owner "root"
  group "root"
  mode 0644
end


new_hostname = "#{node['name']}"
new_fqdn = "#{new_hostname}.#{node['cluster']}.tempo.ai"

execute "hostname --file /etc/hostname" do
  action :nothing
end

file "/etc/hostname" do
  content "#{node['name']}"
  notifies :run, resources(:execute => "hostname --file /etc/hostname"), :immediately
  ignore_failure true
end

# update the node attributes during the chef run, so that the new values can be used later
node.automatic_attrs["hostname"] = new_hostname
node.automatic_attrs["fqdn"] = new_fqdn