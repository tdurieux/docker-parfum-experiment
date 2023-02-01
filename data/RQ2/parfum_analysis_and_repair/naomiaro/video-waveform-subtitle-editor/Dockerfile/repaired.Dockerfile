FROM node:carbon

RUN echo deb http://ftp.uk.debian.org/debian jessie-backports main \
    >>/etc/apt/sources.list

RUN apt-get update && apt-get install --no-install-recommends ffmpeg -y && rm -rf /var/lib/apt/lists/*;

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm install && npm cache clean --force;

# Bundle app source
COPY . .

EXPOSE 80

CMD [ "npm", "run", "dev" ]
