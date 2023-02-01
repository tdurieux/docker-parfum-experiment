FROM node:latest

ADD . /usr/src/app
WORKDIR /usr/src/app
RUN apt-get update --fix-missing && apt-get install --no-install-recommends -y make && rm -rf /var/lib/apt/lists/*;
RUN make install
RUN make build

CMD ["node", "build/netclix.js"]
