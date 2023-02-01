FROM node:latest

# Note: npm is v2.7.6
RUN npm install -g ember-cli@0.2.7 && npm cache clean --force;
RUN npm install -g phantomjs@1.9.16 && npm cache clean --force;

# install watchman
RUN \
	git clone https://github.com/facebook/watchman.git &&\
	cd watchman &&\
	git checkout v3.1 &&\
	./autogen.sh && \
	./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
	make && \
	make install


ADD . /app

WORKDIR /app

RUN npm install && npm cache clean --force;

EXPOSE "35729" "4200"
