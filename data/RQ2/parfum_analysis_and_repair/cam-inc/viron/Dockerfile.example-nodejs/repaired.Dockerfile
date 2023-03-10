FROM node:16

RUN mkdir -p /viron/example/nodejs
RUN mkdir -p /viron/packages/nodejs
RUN chown -R root:root /viron
ENV HOME /viron
USER root
WORKDIR $HOME

# Setup project
COPY package.json $HOME/package.json
COPY package-lock.json $HOME/package-lock.json
COPY example/nodejs/package.json $HOME/example/nodejs/package.json
COPY packages/nodejs/package.json $HOME/packages/nodejs/package.json
COPY packages/linter/package.json $HOME/packages/linter/package.json
#RUN npm install --production --no-progress && npm cache verify
RUN npm install --no-progress && npm cache verify && npm cache clean --force;

# Copy packages
COPY packages/nodejs/src $HOME/packages/nodejs/src
COPY packages/linter/src $HOME/packages/linter/src

# Copy source files
COPY example/nodejs/src $HOME/example/nodejs/src
COPY example/nodejs/tsconfig.json $HOME/example/nodejs/tsconfig.json
COPY example/nodejs/cert $HOME/example/nodejs/cert

EXPOSE 3000
USER root

WORKDIR $HOME/example/nodejs
CMD npm run dev
