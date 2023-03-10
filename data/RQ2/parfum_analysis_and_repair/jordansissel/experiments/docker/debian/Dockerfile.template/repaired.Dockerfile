FROM stackbrew/debian:TAG
MAINTAINER Jordan Sissel <jls@semicomplete.com>
# Originally taken from https://github.com/tianon/dockerfiles

ADD setup.sh /tmp/setup.sh
RUN bash /tmp/setup.sh

EXPOSE 22
CMD ["/sbin/init"]