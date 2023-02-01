# HFX2.0 Dockerfile
FROM node:stretch-slim

## Container
LABEL maintainer="Lrrr <lrrr@hackforums.net>""
WORKDIR /app
COPY . .

## Yarn
### Update apt
RUN apt update && apt-get install --no-install-recommends -y yarn && rm -rf /var/lib/apt/lists/*; ### Install yarn *(apt doesn't deal with cli installs, so we use apt-get to install)*


### Add gulp
RUN yarn global add gulp

### Add yarn dependencies
RUN yarn

### Build gulp
RUN gulp build
