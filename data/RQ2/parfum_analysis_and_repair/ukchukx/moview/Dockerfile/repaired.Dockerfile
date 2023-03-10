# ----------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# @trenpixster wrote this file. As long as you retain this notice you
# can do whatever you want with this stuff. If we meet some day, and you think
# this stuff is worth it, you can buy me a beer in return
# ----------------------------------------------------------------------------

# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
#
# Usage Example : Run One-Off commands
# where <VERSION> is one of the baseimage-docker version numbers.
# See : https://github.com/phusion/baseimage-docker#oneshot for more examples.
#
#  docker run --rm -t -i phusion/baseimage:<VERSION> /sbin/my_init -- bash -l
#
# Thanks to @hqmq_ for the heads up
FROM phusion/baseimage:0.11
MAINTAINER Nizar Venturini @trenpixster

# Important!  Update this no-op ENV variable when this Dockerfile
# is updated with the current date. It will force refresh of all
# of the base images and things like `apt-get update` won't be using
# old cached versions when the Dockerfile is built.
ENV REFRESHED_AT 2018-12-20

# Set correct environment variables.

# Setting ENV HOME does not seem to work currently. HOME is unset in Docker container.
# See bug : https://github.com/phusion/baseimage-docker/issues/119
#ENV HOME /root
# Workaround:
RUN echo /root > /etc/container_environment/HOME

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Baseimage-docker enables an SSH server by default, so that you can use SSH
# to administer your container. In case you do not want to enable SSH, here's
# how you can disable it. Uncomment the following:
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR /tmp

# See : https://github.com/phusion/baseimage-docker/issues/58
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get -qq update

RUN apt-get install --no-install-recommends -y sudo wget git tzdata curl inotify-tools build-essential zip unzip && \
    echo "deb http://packages.erlang-solutions.com/ubuntu $(lsb_release -sc) contrib" >> /etc/apt/sources.list && \
    wget -qO - https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | sudo apt-key add - && \
    curl -f -sL https://deb.nodesource.com/setup_9.x | sudo -E bash - && \
    apt-get update && rm -rf /var/lib/apt/lists/*;

# Install Erlang
RUN apt-get install --no-install-recommends -y esl-erlang=1:21.2-1 && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    mkdir -p /app/logs

WORKDIR /

# From https://gist.github.com/brienw/85db445a0c3976d323b859b1cdccef9a
ENV MIX_HOST 1976
ENV TZ Africa/Lagos

WORKDIR /app
COPY ./_build/prod/rel/moview/releases/2.0.0/moview.tar.gz .
RUN tar -zxvf moview.tar.gz && rm -f moview.tar.gz


ENTRYPOINT ["bin/moview"]
CMD ["foreground"]
# Start up in 'foreground' mode by default so the container stays running

