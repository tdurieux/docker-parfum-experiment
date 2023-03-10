# Interactive Base Image (gewo/interactive)
FROM gewo/base
MAINTAINER Gebhard Wöstemeyer <g.woestemeyer@gmail.com>

ADD docker_link /usr/local/bin/docker_link
RUN chmod 755 /usr/local/bin/docker_link

 \
RUN apt-get update && \
  apt-get install --no-install-recommends -y zsh vim lftp && rm -rf /var/lib/apt/lists/*; ONBUILD


ONBUILD RUN echo 'docker_link' >> /etc/shell_env
ONBUILD RUN echo 'cd /mnt' >> /etc/shell_env

ONBUILD RUN echo '. /etc/shell_env' >> /etc/bash.bashrc
ONBUILD RUN echo '. /etc/shell_env' >> /etc/zsh/zshenv
