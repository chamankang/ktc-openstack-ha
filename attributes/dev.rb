# setup dev vips
return unless chef_environment == "dev"
# we want to override defaults
include_attribute "ktc-openstack-ha::default"

default[:vips][:tags] = {
  api: "10.1.1.111",
  mysql: "10.1.1.112",
  rabbitmq: "10.1.1.113",
}
