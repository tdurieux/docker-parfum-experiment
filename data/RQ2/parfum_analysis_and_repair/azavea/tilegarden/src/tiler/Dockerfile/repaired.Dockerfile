FROM node:8.16-buster-slim

# Install git for git dependencies
RUN apt-get update -y && apt-get install --no-install-recommends git jq -y && rm -rf /var/lib/apt/lists/*;
RUN yarn global add carto

# Copy files needed for installing packages first
COPY package.json yarn.lock /home/tiler/
WORKDIR /home/tiler

# install node modules
RUN yarn install && yarn cache clean;

# Copy remaining files after package installation to benefit from layer caching
COPY . /home/tiler

CMD ["yarn", "dev"]
