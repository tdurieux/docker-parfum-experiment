FROM node:alpine
COPY lib /dockerfile-utils/lib
COPY bin /dockerfile-utils/bin
COPY package.json /dockerfile-utils/package.json
WORKDIR /dockerfile-utils/
RUN npm install --ignore-scripts --production && \
    chmod +x /dockerfile-utils/bin/dockerfile-utils && npm cache clean --force;
ENTRYPOINT [ "/dockerfile-utils/bin/dockerfile-utils" ]
