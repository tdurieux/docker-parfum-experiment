FROM debian:8.5
MAINTAINER Romain Soufflet <romain.soufflet@nanocloud.com>

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install --no-install-recommends -y git nodejs qemu-system-x86 && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt

COPY package.json /tmp/package.json
RUN cd /tmp && npm install && npm cache clean --force;
RUN cp -a /tmp/node_modules /opt/

COPY ./ /opt/

EXPOSE 3000

CMD ["node", "index.js"]
