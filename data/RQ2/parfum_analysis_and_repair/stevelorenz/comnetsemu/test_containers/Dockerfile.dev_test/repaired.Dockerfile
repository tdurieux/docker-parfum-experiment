#
# About: Default image for development, tests and basic examples.
#

FROM ubuntu:20.04

# * Must-Installed packages to use this image for a DockerHost instance:
#
# - bash: Default shell used by the DockerHost
# - iperf, iperf3: Used in Mininet's bandwidth tests.
# - iproute2, net-tools: IP utilities to manage interfaces.
# - iputils-ping: Used in Mininet's pingall tests.
# - telnet: Used by running iperf with Mininet's CLI