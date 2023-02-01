FROM node:18.1-alpine3.15

RUN apk --no-cache add \
    build-base \
    python3 \
    python3-dev \
    libxml2-dev \
    libxslt-dev \
    cmd:pip3 \
    ffmpeg
RUN pip3 install --no-cache-dir wheel streamlink==4.0.*

WORKDIR /app/
COPY package.json /app/
COPY yarn.lock /app/
RUN chown -R node:node /app

USER node

RUN yarn install && yarn cache clean;

CMD [ "yarn", "start" ]
