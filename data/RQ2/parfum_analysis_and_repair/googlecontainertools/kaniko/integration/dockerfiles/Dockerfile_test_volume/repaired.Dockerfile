FROM debian:9.11
RUN mkdir /foo
RUN echo "hello" > /foo/hey
VOLUME /foo/bar /tmp /qux/quux
ENV VOL /baz/bat
VOLUME ["${VOL}"]
RUN echo "hello again" > /tmp/hey