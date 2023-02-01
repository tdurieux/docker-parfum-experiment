FROM node:14-slim AS build

RUN apt update && apt install --no-install-recommends -y rsync && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/build

COPY package.json yarn.lock ./
COPY server/package.json ./server/
COPY client/package.json ./client/
RUN yarn --frozen-lockfile

COPY . ./
RUN yarn build

FROM node:14-slim

RUN apt update && \
  apt install --no-install-recommends -y ffmpeg && \
  apt clean && apt autoclean && rm -rf /var/lib/apt/lists/*;
RUN ffmpeg -version

WORKDIR /usr/app

COPY package.json yarn.lock ./
COPY server/package.json ./server/
# skip client/package.json
RUN yarn --frozen-lockfile --production

COPY --from=build /usr/build/dist ./dist

CMD [ "yarn", "start:prod" ]
