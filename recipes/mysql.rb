#
# Cookbook Name:: ktc-openstack-ha
# Recipe:: default
#
include_recipe "sysctl"
include_recipe "services"
include_recipe "keepalived"

# we install this here cause keepalive doens't
package "ipvsadm"

# initialize the Services (etc) connection
Services::Connection.new run_context: run_context

vips = {}

# setup Network class
KTC::Network.node = node

# iterate over the defined vips and build the endpoint for each service
# For now we are the authority so we make sure this is always a save
# in the future maybe you might want some external service manageing this
endpoints = []
%w{ mysql }.each do |name|
  vip = node[:vips][name]
  vips[name] = vip
  proto = vip[:proto] || "tcp"
  endpoint = Services::Endpoint.new name,
    ip:    vip[:ip],
    port:  vip[:port],
    proto: proto
  endpoint.save
  endpoints.push endpoint
end

# make KTC::Vips.vips to have only mysql's vip, so does vrrp instance, too.
KTC::Vips.vips = vips
 
#
# setup a VRRP instance on public int
#  right now we aren't using any other int
#  when we need  something on all we can iterate through interface_mapping
#  and build there
keepalived_vrrp "mysql" do
  interface KTC::Network.if_lookup "private"
  virtual_router_id "1#{KTC::Network.last_octet(KTC::Network.address "private")}".to_i
  virtual_ipaddress KTC::Vips.addresses "public"
end

# roll over and setup these vips
#  as virtual  servers
endpoints.each do |ep|
  # load service from etcd
  lb_service = Services::Service.new(ep.name)
  keepalived_virtual_server ep.name do
    vs_listen_ip ep.ip
    vs_listen_port ep.port.to_s
    # TODO: Add this to endpoint data ?
    # Use Source Hashing Scheduling for mysql
    lb_algo  "sh"
    lb_kind  "dr"
    vs_protocol ep.proto
    real_servers lb_service.members.map { |m| m.to_hash }
  end
end
