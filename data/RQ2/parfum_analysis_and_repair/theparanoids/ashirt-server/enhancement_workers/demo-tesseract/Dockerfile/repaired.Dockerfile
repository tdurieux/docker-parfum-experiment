FROM node:16-buster-slim

WORKDIR /app

RUN apt-get update && apt-get upgrade \
    && apt-get install --no-install-recommends -y tesseract-ocr && rm -rf /var/lib/apt/lists/*;

COPY . .
RUN yarn install && yarn cache clean;
RUN yarn build

CMD [ "node", "dist/src/main.js"]
