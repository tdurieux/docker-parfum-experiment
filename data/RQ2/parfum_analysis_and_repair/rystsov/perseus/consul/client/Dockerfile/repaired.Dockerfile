FROM ubuntu:17.10
LABEL maintainer="Denis Rystsov <rystsov.denis@gmail.com>"
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y iputils-ping vim tmux less curl && rm -rf /var/lib/apt/lists/*;
RUN /bin/bash -c "curl -sL https://deb.nodesource.com/setup_8.x | bash -"
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /consul
WORKDIR /consul
COPY test.sh /consul/test.sh
COPY app /consul/app
COPY lib /consul/lib
WORKDIR /consul/app
RUN npm install && npm cache clean --force;
WORKDIR /consul
CMD /consul/test.sh
