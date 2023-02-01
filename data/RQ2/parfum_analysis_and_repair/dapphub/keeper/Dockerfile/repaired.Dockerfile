FROM ubuntu:16.04
RUN apt-get update && apt-get install --no-install-recommends -y bc curl git jshon && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSL https://deb.nodesource.com/setup_6.x | bash
RUN apt-get update && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install -g feedbase && npm cache clean --force;
COPY bin/ /usr/local/bin/
COPY libexec/ /usr/local/libexec/
