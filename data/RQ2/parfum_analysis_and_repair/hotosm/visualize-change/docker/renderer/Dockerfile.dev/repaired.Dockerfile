FROM node:carbon-stretch

WORKDIR /app

RUN apt-get update && apt-get install --no-install-recommends -y xvfb ffmpeg libgconf-2-4 libnss3 libgtk-3-0 libgtk-3-dev && rm -rf /var/lib/apt/lists/*;

RUN yarn global add wait-on

CMD wait-on -l tcp:rabbitmq:5672 && yarn install && yarn dev
