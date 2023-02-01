FROM node:carbon-stretch

WORKDIR /app

COPY renderer .

RUN apt-get update && apt-get install --no-install-recommends -y xvfb ffmpeg libgconf-2-4 libnss3 libgtk-3-0 libgtk-3-dev && rm -rf /var/lib/apt/lists/*;

# info on ARG/ENV and build step: https://github.com/docker/compose/issues/1837
ARG NODE_ENV
ENV NODE_ENV "$NODE_ENV"

RUN yarn global add wait-on
RUN yarn install && yarn cache clean;

CMD wait-on -l tcp:rabbitmq:5672 && yarn start
