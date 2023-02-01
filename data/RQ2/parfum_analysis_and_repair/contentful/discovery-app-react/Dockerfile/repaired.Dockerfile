FROM node:6

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
VOLUME "./:/usr/src/app"
WORKDIR /usr/src/app
RUN npm set progress=false && \
    npm install -g --progress=false yarn && npm cache clean --force;
COPY package.json ./
COPY yarn.lock ./
RUN yarn && yarn cache clean;
COPY ./ ./
EXPOSE 9020

CMD ["yarn", "start"]
