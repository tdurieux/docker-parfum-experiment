FROM alpine:3.15

# 1000 is the first UID assigned to a non root user (debian, ubuntu)
# this can mitigate permissions issues when mapping volumes between host and container
ARG USER_ID=1000
ARG GROUP_ID=1000

ARG STORAGE
ARG BROWSER_CLIENT
ARG DOM_CLIENT
ARG VERSION
ARG BRANCH=main

# core apk packages
RUN apk add --no-cache nodejs npm git

# node-gyp required for some packages like @vscode/sqlite3,
# remove the virtual pkg group at the end
RUN apk add --no-cache --virtual .gyp g++ make py3-pip

# puppeteer apk packages
# install chromium (91.0.4472.164-r0) package, https://pkgs.alpinelinux.org/packages?name=chromium&branch=v3.14
# puppeteer v9.1.1 works with this chromium version, https://github.com/puppeteer/puppeteer/releases
RUN if [ "$BROWSER_CLIENT" = "puppeteer" ] ; then apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont; fi

# puppeteer env variables
# skip installing chromium, puppeteer will be using the installed package
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# add user so we don't need --no-sandbox, https://developers.google.com/web/tools/puppeteer/troubleshooting#running-on-alpine
# match uid, gid coming from the host user
RUN addgroup --system --gid $GROUP_ID gsfuser
RUN adduser --system --uid $USER_ID --ingroup gsfuser gsfuser

# run everything after as non-privileged user
USER gsfuser

RUN mkdir -p /home/gsfuser/Downloads /home/gsfuser/scraper

# install and build get-set-fetch/scraper from github sources
RUN if [ "$VERSION" = "source" ] ; then \
    git clone -b "$BRANCH" --single-branch https://github.com/get-set-fetch/scraper.git /home/gsfuser/scraper \
    && cd /home/gsfuser/scraper \
    && npm ci \
    && npm run build; fi

WORKDIR /home/gsfuser/scraper

# associative arrays not available in sh or ash
# use some nested case statements for linking storage, browser and dom client npm packages to gsf versions
RUN case "$VERSION" in \
    'source') \
        case "$STORAGE" in \
            'sqlite') npm install knex@1.0.7 @vscode/sqlite3@5.0.8 ;; \
            'pg') npm install knex@1.0.7 pg@8.7.3 ;; \
            'mysql') npm install knex@1.0.7 mysql@2.18.1 ;; \
        esac; \
        case "$BROWSER_CLIENT" in \
            'puppeteer') npm install puppeteer@14.3.0 ;; \
            'playwright') npm install playwright-core@1.13.1 playwright-chromium@1.13.1 ;; \
        esac; \
        case "$DOM_CLIENT" in \
            'cheerio') npm install cheerio@1.0.0-rc.10 ;; \
            'jsdom') npm install jsdom@16.7.0 ;; \
        esac \
    ;; \
    esac

# remove node-gyp related packages and switch back to gsfuser
USER root
RUN apk del .gyp
USER gsfuser

# invoke entrypoint as exec form, gsfscrape will receive signals such as SIGTERM
ENTRYPOINT ["/home/gsfuser/scraper/bin/gsfscrape"]

# default arguments
CMD [ "--version" ]