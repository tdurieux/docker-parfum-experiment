FROM alpine:latest

WORKDIR /app

COPY . /app
# RUN sysctl fs.inotify.max_user_watches=16000
RUN apk add --no-cache --update nodejs npm
RUN npm install && npm cache clean --force;

ENV PORT=4444

CMD [ "npm", "start" ]
