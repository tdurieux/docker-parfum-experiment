FROM node

RUN node --version
RUN npm --version
RUN apt-get update && apt-get install --no-install-recommends -y build-essential && apt-get -y --no-install-recommends install sudo && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get -y update && sudo apt-get -y --no-install-recommends install pdftk && sudo apt-get -y --no-install-recommends install imagemagick ghostscript poppler-utils && sudo apt-get -y -y --no-install-recommends install default-jdk -y && rm -rf /var/lib/apt/lists/*;

# Create app directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app/

# Bundle app source
COPY . /usr/src/app
RUN npm install && npm cache clean --force;

EXPOSE 8888
CMD [ "npm", "start" ]
