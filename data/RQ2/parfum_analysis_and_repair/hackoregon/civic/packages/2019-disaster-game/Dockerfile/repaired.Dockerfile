FROM node:12.16.1-stretch

# Create app directory
WORKDIR /usr/src/app

# Secret value provided in CI/CD
ARG SENTRYDSN

# Install yarn
RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install --no-install-recommends -y yarn && rm -rf /var/lib/apt/lists/*;

# Copy and clean the package.json file to remove invalid
# packages since this won't be associated to the workspace
COPY package*.json ./
COPY clean-packages.js clean-packages.js
RUN node clean-packages.js

# Instal dependencies
RUN yarn install --production=true && yarn cache clean;

# Bundle app source
COPY server server
COPY dist dist

# Expose the express server port
EXPOSE 3000

# Always use production env
ENV NODE_ENV production
ENV SENTRYDSN=${SENTRYDSN}
CMD [ "node", "server" ]