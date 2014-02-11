# setup mkd2 vips
return unless chef_environment == "mkd2"
# we want to override defaults
include_attribute "ktc-openstack-ha::default"

default[:vips][:tags] = {
  rabbitmq: "10.5.1.196",
  mysql: "10.5.1.197",
  api: "10.5.1.198"
}
