FROM node:10.16

RUN apt-get update && apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;

RUN npm install --global gulp-cli && npm cache clean --force;

WORKDIR /twitter-mass-follow

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .
