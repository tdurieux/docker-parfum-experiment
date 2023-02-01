FROM node:16-alpine

COPY . /fokus

WORKDIR /fokus

RUN npm install --force && \
    yarn build && \
    yarn global add serve && npm cache clean --force; && yarn cache clean;

CMD ["serve", "-s", "build"]
