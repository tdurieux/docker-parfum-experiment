FROM ubuntu:18.04@sha256:de774a3145f7ca4f0bd144c7d4ffb2931e06634f11529653b23eba85aef8e378
COPY 18.04_deps.sh /deps.sh
RUN /deps.sh && rm /deps.sh
VOLUME /recovery
