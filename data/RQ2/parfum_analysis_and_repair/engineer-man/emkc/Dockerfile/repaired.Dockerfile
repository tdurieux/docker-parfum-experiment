FROM node:14.3.0-stretch

RUN apt update && apt install --no-install-recommends -y inotify-tools libjson-c-dev && rm -rf /var/lib/apt/lists/*;
RUN cd /opt && \
    wget https://github.com/realtux/rmig/releases/download/0.0.3/rmig-0.0.3-linux && \
    chmod +x rmig-0.0.3-linux && \
    ln -s /opt/rmig-0.0.3-linux /usr/bin/rmig

WORKDIR /opt/emkc/platform

CMD ./start
