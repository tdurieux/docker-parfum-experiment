FROM ubuntu:18.04

# Install any needed packages
RUN apt-get update && apt-get install --no-install-recommends -y curl git gnupg && rm -rf /var/lib/apt/lists/*;

# install nodejs
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

WORKDIR /apps
COPY . .

#RUN npm install yarn -g
RUN npm install --global yarn && \
yarn && NODE_ENV=production yarn build:www && npm cache clean --force;

EXPOSE 3000