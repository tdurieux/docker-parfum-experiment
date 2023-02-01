# https://github.com/uyamazak/hc-pdf-server
FROM node:15-alpine3.12 as package_install
LABEL maintainer="uyamazak<yu.yamazaki85@gmail.com>"
COPY package.json yarn.lock /app/
WORKDIR /app
# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
  PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
RUN yarn install --frozen-lockfile && yarn cache clean;

FROM node:15-alpine3.12
LABEL maintainer="uyamazak<yu.yamazaki85@gmail.com>"

# Fastify in docker needs 0.0.0.0
# https://github.com/fastify/fastify/issues/935
ENV HCPDF_SERVER_ADDRESS=0.0.0.0

# Install fonts by apk https://wiki.alpinelinux.org/wiki/Fonts
ARG ADDITONAL_FONTS=""

# https://github.com/puppeteer/puppeteer/blob/main/docs/troubleshooting.md#running-on-alpine
# Installs latest Chromium package.
RUN apk add --update --no-cache \
  chromium \
  nss \
  freetype \
  freetype-dev \
  harfbuzz \
  ca-certificates \
  ttf-freefont ${ADDITONAL_FONTS}

# Install fonts from files
COPY fonts/* /usr/share/fonts/
RUN fc-cache -fv

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

WORKDIR /app
COPY --from=package_install /app/node_modules /app/node_modules
COPY src/ /app/src
COPY test/ /app/test
COPY package.json \
  tsconfig.json \
  tsconfig.build.json \
  tsconfig.eslint.json \
  .prettierrc.js \
  /app/
RUN yarn build

EXPOSE 8080

# Add user so we don't need --no-sandbox.
RUN addgroup -S pptruser && adduser -S -g pptruser pptruser \
  && mkdir -p /home/pptruser/Downloads /app \
  && chown -R pptruser:pptruser /home/pptruser \
  && chown -R pptruser:pptruser /app

# Run everything after as non-privileged user.
USER pptruser

CMD ["yarn", "start"]
