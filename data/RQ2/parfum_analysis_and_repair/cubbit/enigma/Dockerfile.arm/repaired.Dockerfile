ARG TARGET_ARCH

FROM dockcross/linux-${TARGET_ARCH}-lts

ARG TARGET_ARCH

LABEL MAINTAINER="Cubbit srl <connect@cubbit.io>"

ENV NODE_VERSION=14.18.3
ENV TARGET_ARCH=${TARGET_ARCH}
ENV CROSS_COMPILE=""
ENV npm_config_arch=${TARGET_ARCH}

RUN echo "Selected target architecture: ${TARGET_ARCH}"

RUN curl -f -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"

WORKDIR /module

COPY package.json .
COPY package-lock.json .
COPY tsconfig.json .
COPY tslint.json .
COPY binding.gyp .

RUN npm i && npm cache clean --force;

COPY scripts/node/dependencies.js ./scripts/node/
COPY scripts/node/shell ./scripts/node/shell/

RUN node scripts/node/dependencies.js

COPY scripts/node/binary.js ./scripts/node/
COPY scripts/node/install.js ./scripts/node/
COPY scripts/web ./scripts/web/
COPY scripts/publish.js ./scripts/

COPY bindings ./bindings/
COPY src ./src/

RUN npm run build

VOLUME [ "/module/build/stage" ]

COPY scripts/node/docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]