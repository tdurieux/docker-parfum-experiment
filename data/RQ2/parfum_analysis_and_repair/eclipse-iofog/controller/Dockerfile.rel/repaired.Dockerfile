FROM node:gallium-buster AS builder

ARG PKG_VERSION

WORKDIR /tmp

# Required by node-gyp
RUN apt install -y --no-install-recommends python3 && rm -rf /var/lib/apt/lists/*;

RUN npm config set unsafe-perm true

RUN npm i -g npm && npm cache clean --force;

COPY package.json .

COPY . .

RUN npm i && npm cache clean --force;

RUN npm version $PKG_VERSION --allow-same-version

RUN npm pack

FROM node:gallium-alpine3.15

# https://stackoverflow.com/questions/52196518/could-not-get-uid-gid-when-building-node-docker
# Workaround until we fix our node alpine image
RUN npm config set unsafe-perm true

RUN apk add --no-cache sudo logrotate g++ make

COPY logrotate.conf /etc/logrotate.conf

# Install python/pip
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache-dir --no-cache --upgrade pip setuptools

COPY --from=builder /tmp/iofogcontroller-*.tgz /tmp/iofog-controller.tgz

RUN npm i --unsafe-perm -g /tmp/iofog-controller.tgz && \
  rm -rf /tmp/iofog-controller.tgz && \
  iofog-controller config dev-mode --on && npm cache clean --force;

CMD [ "node", "/usr/local/lib/node_modules/iofogcontroller/src/server.js" ]
