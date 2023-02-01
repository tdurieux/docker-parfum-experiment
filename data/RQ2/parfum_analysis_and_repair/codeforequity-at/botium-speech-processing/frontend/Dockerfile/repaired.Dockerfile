FROM ubuntu:18.04

RUN apt-get update && apt-get -y --no-install-recommends install curl gnupg bc && curl -f -sL https://deb.nodesource.com/setup_14.x | bash - && apt-get -y --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y dos2unix sox libsox-fmt-mp3 libttspico-utils ffmpeg && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
COPY ./package.json /app/package.json
RUN npm install --no-optional --production && npm cache clean --force;
COPY . /app
COPY ./resources/.env /app/.env
RUN find . -type f ! -path '*/node_modules/*' -print0 | xargs -0 dos2unix

EXPOSE 56000

RUN groupadd --gid 1000 node && useradd --uid 1000 --gid node --shell /bin/bash --create-home node
RUN chown -R 1000:1000 /app
USER node
CMD npm run start-dist