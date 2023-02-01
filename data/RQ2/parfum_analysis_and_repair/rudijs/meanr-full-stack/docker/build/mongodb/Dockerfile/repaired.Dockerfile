FROM    ubuntu:latest
MAINTAINER rudijs <ooly.me@gmail.com>

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/10gen.list
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl
RUN apt-get update && apt-get install -y --no-install-recommends mongodb-10gen && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["usr/bin/mongod", "-f", "/data/mongodb.conf"]