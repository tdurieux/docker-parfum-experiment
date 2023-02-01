FROM ubuntu:14.04
MAINTAINER jerome.petazzoni@docker.com

# Let's start with some basic stuff.
RUN apt-get update -qq && apt-get install --no-install-recommends -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    lxc \
    iptables && rm -rf /var/lib/apt/lists/*;

# Install Docker from Docker Inc. repositories.
RUN curl -f -sSL https://get.docker.com/ | sh

# Install the magic wrapper.
ADD ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

# Define additional metadata for our image.
VOLUME /var/lib/docker
CMD ["wrapdocker"]

