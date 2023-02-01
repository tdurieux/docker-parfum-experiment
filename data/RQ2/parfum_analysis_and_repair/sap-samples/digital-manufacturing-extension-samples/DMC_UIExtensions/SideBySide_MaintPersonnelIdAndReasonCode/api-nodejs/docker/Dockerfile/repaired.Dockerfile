FROM node:12-slim

# Install node/npm
RUN apt-get -y update && \
        apt-get install --no-install-recommends -y curl && \
        curl -f -sL https://deb.nodesource.com/setup_14.x | bash - && \
        apt-get install --no-install-recommends -y nodejs && \
        apt-get install --no-install-recommends -y dos2unix \
        npm && rm -rf /var/lib/apt/lists/*;

# Create app directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
COPY app/package.json /usr/src/app/
RUN npm install && npm cache clean --force;

# Bundle app source
COPY app /usr/src/app

EXPOSE 8080

CMD npm start