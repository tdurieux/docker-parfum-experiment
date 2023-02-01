FROM ubuntu:20.04

RUN apt-get update -y && apt-get install --no-install-recommends -y locales && \
  locale-gen en_US.UTF-8 && update-locale LC_ALL="en_US.UTF-8" && rm -rf /var/lib/apt/lists/*;
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get upgrade -y && \
  apt-get install --no-install-recommends -y openssh-server gettext-base syslog-ng \
    tmux byobu emacs vim mc htop curl \
    bb cmatrix libaa-bin \
    zsh git && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y mosh iproute2 && rm -rf /var/lib/apt/lists/*;

ADD mosh/entrypoint.sh /usr/bin/entrypoint.sh
ADD mosh/sshd_config /etc/ssh/sshd_config
ADD keys /tmp/
ADD zshrc /tmp/

RUN chmod +x /usr/bin/entrypoint.sh
ADD sanitize-auth-log.sh /usr/bin/sanitize-auth-log.sh
RUN chmod +x /usr/bin/sanitize-auth-log.sh

CMD /usr/bin/entrypoint.sh
