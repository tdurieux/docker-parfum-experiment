FROM ubuntu:14.04
MAINTAINER jerome.petazzoni@docker.com

# Let's start with some basic stuff.
RUN apt-get update -qq
RUN apt-get install --no-install-recommends -qqy iptables ca-certificates lxc && rm -rf /var/lib/apt/lists/*;

# Install Docker from Docker Inc. repositories.
RUN apt-get install --no-install-recommends -qqy apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
RUN apt-get update -qq
RUN apt-get install --no-install-recommends -qqy lxc-docker && rm -rf /var/lib/apt/lists/*;

# Install the magic wrapper.
ADD ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

# Install the dkbuild.
ADD ./dkbuild /usr/local/bin/dkbuild
RUN chmod +x /usr/local/bin/dkbuild

# Define additional metadata for our image.
VOLUME /var/lib/docker

CMD ["wrapdocker"]

