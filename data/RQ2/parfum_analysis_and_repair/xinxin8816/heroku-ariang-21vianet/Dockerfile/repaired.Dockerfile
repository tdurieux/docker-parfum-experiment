FROM node:lts-buster

WORKDIR /app
COPY package.json .
COPY yarn.lock .
RUN yarn && yarn cache clean;
COPY . .
RUN bash setup.sh
CMD ["bash", "start.sh"]
