FROM ubuntu:bionic

ENV CI_USERNAME vagrant
ENV CI_PASSWORD vagrant
ENV CI_HOMEDIR  /home/vagrant
ENV CI_SHELL    /bin/bash

RUN apt-get -y update && \
    mkdir -p /run/sshd && \
    apt-get -y --no-install-recommends install \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg-agent \
      openssh-client \
      openssh-server \
      software-properties-common \
      sudo && rm -rf /var/lib/apt/lists/*;

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    rm -f /usr/lib/tmpfiles.d/systemd-nologin.conf && \
    if ! getent passwd $CI_USERNAME; then \
      useradd -m -d ${CI_HOMEDIR} -s ${CI_SHELL} $CI_USERNAME; \
    fi && \
    echo "${CI_USERNAME}:${CI_PASSWORD}" | chpasswd && \
    echo "${CI_USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir -p /etc/sudoers.d && \
    echo "${CI_USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/${CI_USERNAME} && \
    chmod 0440 /etc/sudoers.d/${CI_USERNAME} && \
    mkdir -p ${CI_HOMEDIR}/.ssh && \
    chown -R ${CI_USERNAME}:${CI_USERNAME} ${CI_HOMEDIR}/.ssh && \
    chmod 0700 ${CI_HOMEDIR}/.ssh && \
    curl -f -L https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub > ${CI_HOMEDIR}/.ssh/vagrant.pub && \
    touch ${CI_HOMEDIR}/.ssh/authorized_keys && \
    grep -q "$(cat ${CI_HOMEDIR}/.ssh/vagrant.pub | awk '{print $2}')" ${CI_HOMEDIR}/.ssh/authorized_keys || cat ${CI_HOMEDIR}/.ssh/vagrant.pub >> ${CI_HOMEDIR}/.ssh/authorized_keys && \
    chown ${CI_USERNAME}:${CI_USERNAME} ${CI_HOMEDIR}/.ssh/authorized_keys && \
    chmod 0600 ${CI_HOMEDIR}/.ssh/authorized_keys

CMD [ "/usr/sbin/sshd", "-D" ]
