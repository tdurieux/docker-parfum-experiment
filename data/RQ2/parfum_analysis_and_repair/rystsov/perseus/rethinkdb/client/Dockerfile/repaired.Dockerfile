FROM ubuntu:17.10
LABEL maintainer="Denis Rystsov <rystsov.denis@gmail.com>"
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y iputils-ping vim tmux less curl && rm -rf /var/lib/apt/lists/*;
RUN /bin/bash -c "curl -sL https://deb.nodesource.com/setup_8.x | bash -"
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /rethink
WORKDIR /rethink
COPY test.sh /rethink/test.sh
COPY app /rethink/app
COPY lib /rethink/lib
WORKDIR /rethink/app
RUN npm install && npm cache clean --force;
WORKDIR /rethink
CMD /rethink/test.sh
