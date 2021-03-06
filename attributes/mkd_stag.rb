# setup mkd_stag vips
return  unless  chef_environment == "mkd_stag"
# we want to override defaults
include_attribute "ktc-openstack-ha::default"

default[:vips] = {
  "mysql" => {
    ip: "20.0.1.253",
    port: 3306,
  },
  "identity-api" => {
    ip: "20.0.1.253",
    port: 5000
  },
  "identity-admin" => {
    ip: "20.0.1.253",
    port: 35357
  },
  "compute-api" => {
    ip: "20.0.1.253",
    port: 8774
  },
  "compute-ec2-api" => {
    ip: "20.0.1.253",
    port: 8773
  },
  "compute-ec2-admin" => {
    ip: "20.0.1.253",
    port: 8773
  },
  "compute-xvpvnc" => {
    ip: "20.0.1.253",
    port: 6081,
    algo: "sh"
  },
  "compute-novnc" => {
    ip: "20.0.1.253",
    port: 6080,
    algo: "sh"
  },
  "network-api" => {
    ip: "20.0.1.253",
    port: 9696
  },
  "image-api" => {
    ip: "20.0.1.253",
    port: 9292
  },
  "image-registry" => {
    ip: "20.0.1.253",
    port: 9191
  },
  "volume-api" => {
    ip: "20.0.1.253",
    port: 8776
  },
  "metering-api" => {
    ip: "20.0.1.253",
    port: 8777
  }

  # options and "mode" are ignored
  # untill we get some http proxy in front of those things that want it
  #
  # example: {
  #  ip: 127.0.0.1
  #  port: 1234
  #  options: %w[ some option settings ]
  #  proto: udp
  #  mode: "http"
  #  algo: sh
  #  kind:  tun
  #  net:  "management"
  # }
}
