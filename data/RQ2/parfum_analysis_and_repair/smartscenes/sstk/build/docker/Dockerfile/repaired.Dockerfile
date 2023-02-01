FROM garthk/node-for-headless-webgl

MAINTAINER Manolis Savva <manolis.savva@gmail.com>

# Copy git source
COPY . /src

# Build client assets
WORKDIR /src
RUN ./build.sh

# Build server assets
WORKDIR /src/server
RUN npm install && npm cache clean --force;

# Change to ssc
WORKDIR /src/ssc
RUN npm install && npm cache clean --force;

EXPOSE 8010

CMD ["bash"]