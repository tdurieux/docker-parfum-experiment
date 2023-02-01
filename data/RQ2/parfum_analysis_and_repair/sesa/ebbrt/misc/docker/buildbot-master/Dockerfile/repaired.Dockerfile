FROM ubuntu:14.04

RUN /bin/echo -e "\
    deb http://archive.ubuntu.com/ubuntu trusty main universe\n\
    deb http://archive.ubuntu.com/ubuntu trusty-updates main universe" > \
    /etc/apt/sources.list
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y python-pip python-dev \
    git && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir buildbot
RUN groupadd -g 5001 buildbot
RUN useradd -u 5001 -g buildbot buildbot
USER buildbot
WORKDIR /buildbotdata
EXPOSE 8010
CMD ["buildbot", "start", "--nodaemon", "master"]
