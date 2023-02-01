FROM node:16-alpine
RUN apk update
RUN apk add --no-cache graphicsmagick-dev

WORKDIR /usr/src/app

# Install dependencies.
COPY package*.json ./
COPY config ./config
COPY gulpfile.js ./
RUN npm install && npm cache clean --force;

# Copy project directory.
COPY . ./
RUN npm run build
RUN npm run test

EXPOSE 3000
ENTRYPOINT [ "npm", "start" ]
