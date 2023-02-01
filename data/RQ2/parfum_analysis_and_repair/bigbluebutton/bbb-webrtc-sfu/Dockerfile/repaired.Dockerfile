FROM node:16-bullseye-slim

RUN apt-get update && apt-get -y --no-install-recommends install \
  git \
  make \
  python3-pip \
  g++ \
  ffmpeg && rm -rf /var/lib/apt/lists/*;

ADD . app

WORKDIR app

ENV NODE_ENV production

RUN cp config/default.example.yml config/production.yml \
 && npm install --unsafe-perm \
 && npm cache clear --force

EXPOSE 3008

CMD [ "npm", "start" ]
