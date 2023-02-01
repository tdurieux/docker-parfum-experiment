FROM node:10.22.0

RUN apt-get update && apt-get install --no-install-recommends yarn -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src

COPY yarn.lock package.json
COPY . .

RUN yarn
RUN yarn build

EXPOSE 3000

CMD ["yarn", "start"]
