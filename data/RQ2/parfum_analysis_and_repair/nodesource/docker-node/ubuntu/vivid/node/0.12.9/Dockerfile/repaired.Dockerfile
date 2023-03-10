FROM nodesource/vivid-base
MAINTAINER William Blankenship <wblankenship@nodesource.com>

RUN curl -f https://deb.nodesource.com/node_0.12/pool/main/n/nodejs/nodejs_0.12.9-1nodesource1~vivid1_amd64.deb > node.deb \
 && dpkg -i node.deb \
 && rm node.deb

RUN npm install -g pangyp\
 && ln -s $(which pangyp) $(dirname $(which pangyp))/node-gyp \
 && npm cache clear --force \
 && node-gyp configure || echo ""

ENV NODE_ENV production
WORKDIR /usr/src/app
CMD ["npm","start"]

RUN apt-get update \
 && apt-get upgrade -y --force-yes \
 && rm -rf /var/lib/apt/lists/*;