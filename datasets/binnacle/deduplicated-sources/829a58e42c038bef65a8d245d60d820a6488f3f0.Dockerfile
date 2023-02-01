FROM ubuntu:16.04

RUN apt-get -q update && apt-get -qy install python3-pip \
    && mkdir /pgwatch2

###
### add webpy source and configure installed components
###

ADD webpy /pgwatch2/webpy
ADD docker/launch-wrapper-webui.sh /pgwatch2

# Get Web UI requirements
RUN pip3 install -r /pgwatch2/webpy/requirements.txt \
    && chgrp -R 0 /pgwatch2 \
    && chmod -R g=u /pgwatch2 \
    && mkdir /pgwatch2/persistent-config \
    && chgrp -R 0 /pgwatch2/webpy /pgwatch2/persistent-config \
    && chmod -R g=u /pgwatch2/webpy /pgwatch2/persistent-config


# Admin UI for configuring servers to be monitored
EXPOSE 8080

VOLUME /pgwatch2/persistent-config

USER 10001

ENTRYPOINT ["/pgwatch2/launch-wrapper-webui.sh"]
