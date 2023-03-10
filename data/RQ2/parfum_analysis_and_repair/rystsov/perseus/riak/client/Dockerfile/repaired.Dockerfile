FROM ubuntu:17.10
LABEL maintainer="Denis Rystsov <rystsov.denis@gmail.com>"
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y iputils-ping vim tmux less curl && rm -rf /var/lib/apt/lists/*;
RUN /bin/bash -c "curl -sL https://deb.nodesource.com/setup_8.x | bash -"
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /riak
WORKDIR /riak
COPY test.sh /riak/test.sh
COPY app /riak/app
COPY lib /riak/lib
WORKDIR /riak/app
RUN npm install && npm cache clean --force;
WORKDIR /riak
CMD /riak/test.sh
