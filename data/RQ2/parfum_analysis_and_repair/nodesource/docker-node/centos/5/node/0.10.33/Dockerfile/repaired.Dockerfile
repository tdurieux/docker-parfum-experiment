FROM nodesource/centos5-base
MAINTAINER William Blankenship <wblankenship@nodesource.com>

RUN curl -f -sL -o ns.rpm https://rpm.nodesource.com/pub/el/5/x86_64/nodejs-0.10.33-1nodesource.el5.centos.x86_64.rpm \
 && rpm -i --nosignature --force ns.rpm \
 && rm -f ns.rpm

RUN npm install -g pangyp\
 && ln -s $(which pangyp) $(dirname $(which pangyp))/node-gyp \
 && npm cache clear --force \
 && node-gyp configure || echo ""

ENV NODE_ENV production
WORKDIR /usr/src/app
CMD ["npm","start"]