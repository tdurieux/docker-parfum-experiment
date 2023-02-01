FROM debian:jessie

EXPOSE 22

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -qq update
RUN apt-get -qq -y --no-install-recommends install openssh-server && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qq -y --no-install-recommends install krb5-user && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qq -y --no-install-recommends install vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qq clean

# configuration for the SSH server
COPY sshd_config /etc/ssh/sshd_config
# configuration for the SSH client
COPY ssh_config /etc/ssh/ssh_config