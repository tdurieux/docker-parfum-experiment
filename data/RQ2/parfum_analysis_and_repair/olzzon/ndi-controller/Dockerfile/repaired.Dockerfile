FROM node:16.6-buster
RUN apt-get update && apt-get install --no-install-recommends -y libavahi-common-dev libavahi-client-dev build-essential && rm -rf /var/lib/apt/lists/*;
COPY . /opt/ndi-ember-mtx
COPY ./lib/x86_64-linux-gnu /usr/lib
WORKDIR /opt/ndi-ember-mtx
EXPOSE 5901/tcp
EXPOSE 9000/tcp
EXPOSE 5960-6100/tcp
EXPOSE 5960-6100/udp
CMD ["yarn", "start"]
