FROM node:10.11
EXPOSE 8080
WORKDIR /app
RUN mkdir -p /app/node_modules /app
COPY package.json /app/package.json
RUN yarn --ignore-scripts && yarn cache clean;
COPY . /app
RUN yarn && yarn cache clean;
ENV SERVICE_ACCOUNT_DATA '{}'
ENV APP portfolio-browser
RUN yarn build $APP && yarn cache clean;
CMD yarn start $APP --port 8080 --static
