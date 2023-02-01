FROM node:14.5.0

# Installing node-gyp dependencies and git
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

# Installing golang
RUN curl -f -O https://dl.google.com/go/go1.14.6.linux-amd64.tar.gz
RUN sha256sum go1.14.6.linux-amd64.tar.gz
RUN tar xvf go1.14.6.linux-amd64.tar.gz && rm go1.14.6.linux-amd64.tar.gz
RUN chown -R root:root ./go
RUN mv go /usr/local
ENV PATH=$PATH:/usr/local/go/bin

# Installing node-gyp
RUN npm install -g node-gyp@7.1.2 && npm cache clean --force;
RUN node-gyp -v