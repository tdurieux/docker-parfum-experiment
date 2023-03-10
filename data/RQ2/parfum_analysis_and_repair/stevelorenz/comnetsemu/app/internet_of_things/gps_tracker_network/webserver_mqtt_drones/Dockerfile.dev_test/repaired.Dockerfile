#
# About: Default image for development, tests and basic examples.
#

# Docker official image with docker-in-docker (dind)
FROM docker:stable-dind

RUN apk update && apk upgrade

# * Must-Installed packages to use this image for a DockerHost instance:
# - bash: Used by startShell method in DockerHost, used as the default interactive shell
# - iproute2: IP utilities to manage interfaces.
# - iperf: Used in Mininet's bandwidth tests.
# - busybox-extras: Includes telnet, used by running iperf with Mininet's CLI
RUN apk add --no-cache bash bash-completion
RUN apk add --no-cache iproute2 busybox-extras iperf

# * Additional packages for some examples in folder: ../examples/
# - stress-ng: Updated version of stress (ref: https://www.cyberciti.biz/faq/stress-test-linux-unix-server-with-stress-ng/)
RUN apk add --no-cache stress-ng curl tcpdump netcat-openbsd

ENV HOME /root
WORKDIR /root

# Define default command.
CMD ["bash"]
