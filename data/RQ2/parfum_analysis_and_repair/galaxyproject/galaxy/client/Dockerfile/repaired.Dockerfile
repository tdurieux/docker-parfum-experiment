FROM digitallyseamless/nodejs-bower-grunt
RUN mkdir /gx

COPY package.json /gx/package.json

RUN cd /gx && \
    npm install -g && \
    cd / && \
    rm -rf /gx && npm cache clean --force;

WORKDIR /data/client
ADD ./.docker-build.sh /build.sh
CMD ["/build.sh"]
