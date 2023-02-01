FROM node
MAINTAINER AJ Bowen <aj@soulshake.net>

RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN npm install -g forever && npm cache clean --force;

RUN git clone https://github.com/yaronn/wopr.git
WORKDIR /wopr
RUN npm install && npm cache clean --force;

EXPOSE 80
ENV PORT 80

# Some envvars are needed to correctly render the graphics
ENV LANG=en_US.utf8
ENV TERM=xterm-256color

# Copy /data directory; this can also be mounted at runtime and changes will be reloaded live
COPY data /data
COPY bin/ /src/bin/

WORKDIR /wopr/server
CMD ["/src/bin/wopr"]
