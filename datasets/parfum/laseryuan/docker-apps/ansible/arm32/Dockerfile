FROM debian:stretch-slim

ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
      curl ca-certificates \
      openssh-server `#ssh`\
      libffi-dev libssl-dev python-dev build-essential `#for build ansible`\
      gnupg2 dirmngr psmisc `#for gpg`\
      python3-dev \
      python3-pip \
      sudo \
      sshpass `# for ansible use password to access ssh` \
      && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* `# remove tmp files`

RUN pip3 install --upgrade setuptools pip

# Install ansible
RUN pip install ansible

RUN useradd -ms /bin/bash ansible

USER ansible
WORKDIR /home/ansible/app

RUN ansible-galaxy install \
      markosamuli.pyenv,v4.0.1

COPY --chown=ansible ./docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["run"]
