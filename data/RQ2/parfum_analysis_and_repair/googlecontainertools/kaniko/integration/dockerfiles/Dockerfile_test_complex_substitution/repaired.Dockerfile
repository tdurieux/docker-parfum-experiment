FROM docker.io/library/busybox:latest@sha256:afe605d272837ce1732f390966166c2afff5391208ddd57de10942748694049d
RUN echo ${s%s}