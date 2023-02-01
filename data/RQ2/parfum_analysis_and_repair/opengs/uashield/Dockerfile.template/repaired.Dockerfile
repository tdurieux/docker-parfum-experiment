FROM balenalib/%%BALENA_MACHINE_NAME%%-node:16

RUN mkdir -p /code
WORKDIR /code

COPY yarn.lock /code/
COPY packageheadless.json /code/package.json
RUN yarn install && yarn cache clean;
COPY . /code/
RUN yarn build:headless

ENTRYPOINT ["yarn", "start:headless"]

