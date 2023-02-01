FROM node:14
LABEL description="Node 14 image for PixelOven"
LABEL maintainer="Brian Gebel <brian@pixeloven.com>"

# Set working directory
ARG APP_PATH=/usr/src/app
WORKDIR ${APP_PATH}

# Install system level locales
RUN apt-get update && \
    apt-get install --no-install-recommends -y locales && \
    apt-get clean all && rm -rf /var/lib/apt/lists/*;
RUN localedef -i en_US -f UTF-8 en_US.UTF-8

# Update tooling
RUN npm install -g npm && \
    npm install -g lerna && \ 
    npm install -g pm2 && \
    curl -f --compressed -o- -L https://yarnpkg.com/install.sh | bash && npm cache clean --force;

#  docker run --rm -v ~/workspace/pixeloven/packages/pixeloven-webpack/bundler:/usr/src/app pixeloven/node:12 ls
# we don't want to mount it so node modules go to host