FROM node:16-buster-slim
RUN apt update && apt upgrade -q -y && apt install --no-install-recommends openssl git neofetch curl speedtest-cli -q -y && rm -rf /var/lib/apt/lists/*;
COPY . /lazybot
WORKDIR /lazybot
RUN yarn install && yarn cache clean;
RUN yarn build
CMD ["yarn", "start"]