FROM busybox
WORKDIR /foo
VOLUME  [ "/foo" ]
RUN echo