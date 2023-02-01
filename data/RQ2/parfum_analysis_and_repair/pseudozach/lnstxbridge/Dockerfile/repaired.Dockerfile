FROM ubuntu:20.04

RUN apt-get update
RUN apt-get -y --no-install-recommends install curl gnupg git rsync build-essential && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get -y --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
# COPY package-docker.json ./package.json
COPY . ./
RUN npm install && npm cache clean --force;
RUN npm run compile

EXPOSE 9002
CMD [ "npm", "run", "start" ]