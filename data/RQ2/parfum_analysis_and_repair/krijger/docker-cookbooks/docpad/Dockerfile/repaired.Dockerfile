FROM quintenk/nodejs

MAINTAINER Quinten Krijger "https://github.com/Krijger"

RUN npm install -g docpad@6.63 && npm cache clean --force;
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /var/lib/docpad/project
ADD .docpad.cson /
EXPOSE 9778
WORKDIR /var/lib/docpad/project
ENTRYPOINT ["docpad"]
