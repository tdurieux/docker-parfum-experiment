FROM node:14

RUN apt-get update \
    && apt-get install --no-install-recommends -y libusb-1.0-0 libusb-1.0-0-dev libudev-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package.json yarn.lock .

COPY  src/logic/contracts/artifacts ./src/logic/contracts/artifacts

RUN yarn install && yarn cache clean;

COPY . .

EXPOSE 3000

CMD ["yarn", "start"]
