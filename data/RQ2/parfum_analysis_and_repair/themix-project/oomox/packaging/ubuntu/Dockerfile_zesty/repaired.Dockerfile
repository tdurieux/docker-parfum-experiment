FROM ubuntu:zesty
WORKDIR /opt/oomox
RUN sed -i -re 's/([a-z]{2}\.)?archive.ubuntu.com|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list && \
    apt-get update
CMD ["/bin/bash", "./packaging/ubuntu/create_ubuntu_package.sh", "control", "--install"]
RUN apt-get update && \
	apt-get install --no-install-recommends -y make gettext fakeroot && rm -rf /var/lib/apt/lists/*;
#COPY . /opt/oomox/

# vim: set ft=dockerfile :
