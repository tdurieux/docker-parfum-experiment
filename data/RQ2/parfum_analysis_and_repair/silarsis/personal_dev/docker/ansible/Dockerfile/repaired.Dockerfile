# Ansible "server"
FROM silarsis/ssh-server
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -yq --no-install-recommends install python-software-properties; rm -rf /var/lib/apt/lists/*; \
  add-apt-repository ppa:rquillo/ansible -y; \
  apt-get -yq update; \
  apt-get -yq --no-install-recommends install ansible

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
