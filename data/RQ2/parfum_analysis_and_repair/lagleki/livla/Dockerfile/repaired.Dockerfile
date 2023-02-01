FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN apt-get update

RUN apt-get install --no-install-recommends -y build-essential software-properties-common curl vim && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y python3 python3-dev && rm -rf /var/lib/apt/lists/*;

# get install script and pass it to execute:
RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash
# and install node
RUN apt-get install -y --no-install-recommends nodejs && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y rsync && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /livla/build/dumps
COPY src/package*.json /livla/
COPY src/tsconfig.json /livla/
WORKDIR /livla
RUN npm i ; npm cache clean --force; npm i -g npm-check-updates pm2@latest typescript
CMD ["pm2-runtime", "/livla/src/livla/index.js"]
