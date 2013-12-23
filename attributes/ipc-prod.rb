# setup ipc_stag vips
return unless chef_environment == "ipc-prod"
# we want to override defaults
include_attribute "ktc-openstack-ha::default"

default[:vips][:tags] = {
  rabbitmq: "10.4.16.34",
  mysql: "10.4.16.35",
  api: "10.4.16.36"
}
