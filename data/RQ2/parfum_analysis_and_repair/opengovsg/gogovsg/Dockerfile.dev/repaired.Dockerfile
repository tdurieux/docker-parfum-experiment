FROM --platform=amd64 node:14-alpine3.12

LABEL maintainer="Open Government Products" email="go@open.gov.sg"

WORKDIR /usr/src/gogovsg

# For Express server
EXPOSE 8080

# For dev webpack server only, proxies to localhost:8080
EXPOSE 3000

RUN apk update && apk add --no-cache ttf-freefont && rm -rf /var/cache/apk/*

# Installs IBMPlexSans-Regular.ttf for QRCodeService.
RUN wget https://github.com/IBM/plex/blob/master/IBM-Plex-Sans/fonts/complete/ttf/IBMPlexSans-Regular.ttf?raw=true -O /usr/share/fonts/TTF/IBMPlexSans-Regular.ttf
RUN fc-cache -f

# Install libraries
COPY package.json package-lock.json ./

RUN npm ci

COPY . ./
