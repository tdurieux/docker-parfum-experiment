FROM ubuntu:20.04

RUN apt-get update -y && apt-get install --no-install-recommends -y locales && \
  locale-gen en_US.UTF-8 && update-locale LC_ALL="en_US.UTF-8" && rm -rf /var/lib/apt/lists/*;
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get upgrade -y && \
  apt-get install --no-install-recommends -y openssh-server gettext-base syslog-ng \
    tmux byobu emacs vim mc htop curl \
    bb cmatrix libaa-bin \
    zsh git && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y libpam-yubico && rm -rf /var/lib/apt/lists/*;

ADD yubikey-pam/entrypoint.sh /usr/bin/entrypoint.sh
ADD yubikey-pam/sshd_config /etc/ssh/sshd_config
ADD yubikey-pam/pam_sshd /etc/pam.d/sshd
ADD yubikey-pam/yubico_passw /var/yubico_passw
ADD zshrc /tmp/

RUN chmod +x /usr/bin/entrypoint.sh
CMD /usr/bin/entrypoint.sh

