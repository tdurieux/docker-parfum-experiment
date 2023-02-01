FROM zenika/alpine-node
RUN npm i -g truffle \
	&& npm i -g ethereumjs-testrpc \
	&& npm i -g gulp-cli \
	&& npm i -g gulp && npm cache clean --force;
RUN apk update \
	&& apk add --no-cache socat
COPY ./package.json /usr/src
RUN cd /usr/src \
	&& npm i -D \
	&& npm cache clean --force
CMD truffle version
