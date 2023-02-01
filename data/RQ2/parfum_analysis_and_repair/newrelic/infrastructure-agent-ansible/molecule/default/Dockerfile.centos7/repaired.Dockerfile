FROM centos:7

# Run a system update so the system doesn't overwrite the fake systemctl later
RUN yum update -y
# Install sudo which is required by targz installation script
RUN yum install -y sudo && rm -rf /var/cache/yum

# Adding fake systemctl
RUN curl -f https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl.py -o /usr/bin/systemctl
