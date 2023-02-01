FROM node:8.9.4 as PACKAGE
  WORKDIR /usr/src/app
  COPY package.json ./
  RUN sed -i -e 's/^  "version": "[0-9.]\+",$//' package.json

FROM node:8.9.4
  WORKDIR /usr/src/app
  ENV NODE_ENV production
  ENV PATHS__FFMPEG avconv
  ENV PATHS__FFPROBE avprobe

  RUN apt-get update && apt-get install --no-install-recommends libav-tools -y && rm -rf /var/lib/apt/lists/*;

  COPY --from=PACKAGE /usr/src/app ./
  COPY yarn.lock ./
  RUN yarn --pure-lockfile
  COPY ./src ./src

  CMD [ "node", "src" ]
  HEALTHCHECK CMD curl -f http://localhost:8000/healthcheck || exit 1
