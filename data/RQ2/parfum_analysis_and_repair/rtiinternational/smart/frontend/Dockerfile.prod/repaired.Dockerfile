FROM node:latest
RUN apt-get update && apt-get install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;
WORKDIR /code
RUN yarn install && yarn cache clean;
RUN yarn global add webpack
ADD . /code
ENV NODE_ENV production
RUN webpack
EXPOSE 8080