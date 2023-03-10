FROM node:11

WORKDIR /usr/hnsd

RUN apt-get update
RUN apt-get install --no-install-recommends libunbound-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends dnsutils -y && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/handshake-org/hnsd.git /usr/hnsd

RUN sed -i 's/ub_callback_type/ub_callback_t/g' src/rs_worker.h

RUN sed -i 's/ub_callback_type/ub_callback_t/g' src/rs_worker.c

RUN ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make

COPY ./run.hnsd.sh run.hnsd.sh

RUN sed -i -e 's/\r$//' run.hnsd.sh

RUN chmod 0775 run.hnsd.sh

WORKDIR /usr/hsdProxy
RUN mkdir favicon_cache
RUN npm install request --save && npm cache clean --force;
RUN npm install get-website-favicon --save && npm cache clean --force;
RUN npm install ico-to-png --save && npm cache clean --force;
RUN npm install anyproxy --save && npm cache clean --force;
RUN npm install geoip-lite --save && npm cache clean --force;
RUN ./node_modules/anyproxy/bin/anyproxy-ca -g
COPY ./resolv.conf resolv.conf
COPY ./proxyRule.js proxyRule.js
COPY ./getFavicon.js getFavicon.js
COPY ./getNetworkMapLocations.js getNetworkMapLocations.js
COPY ./runProxy.js runProxy.js
COPY ./startProxy.sh /usr/local/bin/docker-entrypoint.sh
RUN sed -i -e 's/\r$//' /usr/local/bin/docker-entrypoint.sh
RUN chmod 0775 /usr/local/bin/docker-entrypoint.sh

WORKDIR /usr/hnsd

EXPOSE 12937 12938 13937 13938 13939 15937 15938 15939 3008 5301 13038 15359
