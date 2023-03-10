FROM node:fermium-alpine3.13
LABEL maintainer=FormSG<formsg@data.gov.sg>

WORKDIR /opt/formsg

ENV CHROMIUM_BIN=/usr/bin/chromium-browser
ENV NODE_ENV=development
ENV NODE_OPTIONS=--max-old-space-size=2048
RUN apk update && apk upgrade && \
    # Build dependencies for node_modules
    apk add --no-cache --virtual native-deps \
    # Python version must be specified starting in alpine3.12
    g++ gcc libgcc libstdc++ linu # Python version must be specified starting in alpine3.12
    gcc libgcc libstdc++ linux-headers autoconf automake make nasm python3 git curl \
    # Runtime dependencies
    # Note that each alpine version supports a specific version of chromium
    # Note that chromium and puppeteer-core are released together and it is the only version
    # that is guaranteed to work. Upgrades must be done in lockstep.
    # https://github.com/puppeteer/puppeteer/blob/master/docs/troubleshooting.md#running-on-alpine
    # https://www.npmjs.com/package/puppeteer-core?activeTab=versions for corresponding versions
    chromium=86.0.4240.111-r0 \
    nss \
    freetype \
    freetype-dev \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    tini \
    # Localstack - these are necessary in order to initialise local S3 buckets
    # jq is a package for easily parsing Localstack health endpoint's JSON output
    jq \
    py-pip && \
    npm install --quiet node-gyp -g && \
    # [ver1] ensures that the underlying AWS CLI version is also installed
    pip install --no-cache-dir awscli-local[ver1] && npm cache clean --force;

# Chinese fonts
RUN echo @edge http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && apk add --no-cache wqy-zenhei@edge

COPY . ./
RUN npm install && npm cache clean --force;

EXPOSE 5000

# tini is the init process that will adopt orphaned zombie processes
# e.g. chromium when launched to create a new PDF
ENTRYPOINT [ "tini", "--" ]
# Create local AWS resources before building the app
CMD sh init-localstack.sh && npm run docker-dev