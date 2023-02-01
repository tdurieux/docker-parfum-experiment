FROM node:8

RUN node --version
RUN npm --version
RUN apt-get update && apt-get install --no-install-recommends -y build-essential && apt-get -y --no-install-recommends install sudo && rm -rf /var/lib/apt/lists/*;

# Create app directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app/

# Bundle app source
COPY . /usr/src/app

RUN npm install && npm cache clean --force;

EXPOSE 8080
CMD npm run dev
