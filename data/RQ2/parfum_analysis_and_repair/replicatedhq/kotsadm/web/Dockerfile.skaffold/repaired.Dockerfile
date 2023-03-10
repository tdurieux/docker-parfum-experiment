FROM node:8
EXPOSE 3000 9229

ADD ./package.json /src/package.json
ADD ./yarn.lock /src/yarn.lock
WORKDIR /src
RUN yarn install --silent --frozen-lockfile && yarn cache clean;

ADD . /src/
WORKDIR /src

EXPOSE 30000
RUN make deps

ENTRYPOINT ["make", "serve"]