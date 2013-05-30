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

execute "hostname --file /etc/hostname" do
  action :nothing
end

file "/etc/hostname" do
  content "#{node['host_name']}"
  notifies :run, resources(:execute => "hostname --file /etc/hostname"), :immediately
  ignore_failure true
end