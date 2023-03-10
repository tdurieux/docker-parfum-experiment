ARG UBUNTU_VERSION

FROM ubuntu:$UBUNTU_VERSION

ARG SSH_USER

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && \
    apt-get -yq dist-upgrade && \
    apt-get install -yq --no-install-recommends openssh-server git sudo vim tzdata && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    truncate -s 0 /var/log/*log

# Make temporary dir for ssh server (should not be necessary)
RUN mkdir -p -m0755 /var/run/sshd

# Set up git user
RUN useradd -m -s /bin/bash $SSH_USER

COPY ./lib/repo/authorized_key_command.sh /authorized_key_command.sh
COPY ./lib/repo/markus-git-shell.sh /markus-git-shell.sh

RUN chown "$SSH_USER:$SSH_USER" /markus-git-shell.sh && \
    chmod 700 /markus-git-shell.sh && \
    chmod u=rw,go=rx /authorized_key_command.sh && \
    mkdir -p /home/${SSH_USER}/.ssh && \
    chmod 700 /home/${SSH_USER}/.ssh && \
    chown "$SSH_USER:$SSH_USER" /home/${SSH_USER}/.ssh

COPY ./.dockerfiles/git-ssh.rc /home/${SSH_USER}/.ssh/rc

RUN chown "$SSH_USER:$SSH_USER" /home/${SSH_USER}/.ssh/rc

RUN printf "Match User ${SSH_USER}\n\
 PermitRootLogin no\n\
 AuthorizedKeysFile none\n\
 AuthorizedKeysCommand /authorized_key_command.sh\n\
 AuthorizedKeysCommandUser ${SSH_USER}\n"\
>> /etc/ssh/sshd_config

EXPOSE 22