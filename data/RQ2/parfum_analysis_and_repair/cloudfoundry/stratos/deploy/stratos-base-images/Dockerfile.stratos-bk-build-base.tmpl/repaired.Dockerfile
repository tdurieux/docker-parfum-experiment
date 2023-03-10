FROM {{GO_BUILD_BASE}}

RUN useradd -ms /bin/bash stratos && \
    mkdir -p /home/stratos && \
    chown -R stratos /home/stratos && \
    chgrp -R users /home/stratos

RUN cd / && wget https://nodejs.org/dist/v12.13.0/node-v12.13.0-linux-x64.tar.xz && \
    tar -xf node-v12.13.0-linux-x64.tar.xz && \
    rm node-v12.13.0-linux-x64.tar.xz
ENV USER=stratos
ENV PATH=$PATH:/node-v12.13.0-linux-x64/bin
USER stratos
WORKDIR /home/stratos