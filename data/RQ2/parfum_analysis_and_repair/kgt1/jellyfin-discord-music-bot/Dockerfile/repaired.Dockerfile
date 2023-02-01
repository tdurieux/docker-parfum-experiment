FROM node:12.18.3-alpine
RUN apk add --no-cache ffmpeg

COPY . /app
WORKDIR /app
RUN npm install --only=production && npm cache clean --force;
RUN npm run postinstall

CMD node parseENV.js && npm run start