FROM node:fermium-alpine3.13 AS node-modules-builder
# node-modules-builder stage installs/compiles the node_modules folder
# Python version must be specified starting in alpine3.12
RUN apk update && apk upgrade && \
    apk --no-cache add --virtual native-deps \
    g++ gcc libgcc libstdc++ linux-headers autoconf automake make nasm python3 git curl && \
    npm install --quiet node-gyp -g && npm cache clean --force;
WORKDIR /opt/formsg
COPY package* /opt/formsg/
RUN npm ci
COPY . /opt/formsg

# This stage builds the final container
FROM node:fermium-alpine3.13
LABEL maintainer=FormSG<formsg@data.gov.sg>
WORKDIR /opt/formsg

# Install node_modules from node-modules-builder
COPY --from=node-modules-builder /opt/formsg /opt/formsg

# Install chromium from official docs
# https://github.com/puppeteer/puppeteer/blob/master/docs/troubleshooting.md#running-on-alpine
# Note that each alpine version supports a specific version of chromium
# Note that chromium and puppeteer-core are released together and it is the only version
# that is guaranteed to work. Upgrades must be done in lockstep.
# https://www.npmjs.com/package/puppeteer-core?activeTab=versions for corresponding versions

RUN apk add --no-cache \
    chromium=86.0.4240.111-r0 \
    nss \
    freetype \
    freetype-dev \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    tini
# This package is needed to render Chinese characters in autoreply PDFs
RUN echo @edge http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && apk add --no-cache wqy-zenhei@edge
ENV CHROMIUM_BIN=/usr/bin/chromium-browser

# Run as non-privileged user
RUN addgroup -S formsguser && adduser -S -g formsguser formsguser
USER formsguser

ENV NODE_ENV=production
EXPOSE 4545

# tini is the init process that will adopt orphaned zombie processes
# e.g. chromium when launched to create a new PDF
ENTRYPOINT [ "tini", "--" ]
CMD [ "npm", "start" ]
