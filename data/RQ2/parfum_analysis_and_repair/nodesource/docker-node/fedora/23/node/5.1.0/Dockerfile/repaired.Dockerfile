FROM nodesource/fedora23-base
MAINTAINER William Blankenship <wblankenship@nodesource.com>

RUN curl -f -sL -o ns.rpm https://rpm.nodesource.com/pub_5.x/fc/23/x86_64/nodejs-5.1.0-2nodesource.fc23.x86_64.rpm \
 && rpm -i --nosignature --force ns.rpm \
 && rm -f ns.rpm

RUN npm install -g pangyp\
 && ln -s $(which pangyp) $(dirname $(which pangyp))/node-gyp \
 && npm cache clear --force \
 && node-gyp configure || echo ""

ENV NODE_ENV production
WORKDIR /usr/src/app
CMD ["npm","start"]