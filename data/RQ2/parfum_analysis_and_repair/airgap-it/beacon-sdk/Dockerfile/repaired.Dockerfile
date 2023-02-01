FROM node:12

RUN apt-get update && apt-get install --no-install-recommends -yq git python build-essential && rm -rf /var/lib/apt/lists/*;

# create app directory
RUN mkdir /app
WORKDIR /app

# Install app dependencies
COPY package.json /app
COPY package-lock.json /app

# install dependencies
RUN npm install && npm cache clean --force;

# Bundle app source
COPY . /app

RUN chmod +x ./npm-ci-publish-beta-only.sh
RUN chmod +x ./npm-ci-publish.sh

# set to production
RUN export NODE_ENV=production

# build
RUN npm run build

CMD ["npm", "run", "test"]
