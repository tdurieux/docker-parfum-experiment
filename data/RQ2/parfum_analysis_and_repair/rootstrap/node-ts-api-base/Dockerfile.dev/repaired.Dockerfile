# Check out https://hub.docker.com/_/node to select a new base image
FROM node:14.16.0-alpine
WORKDIR /app
COPY ./package.json .
COPY tsconfig* ./
COPY ormconfig* ./
COPY src ./src
COPY .env* ./
# Uncomment the next line if your laptop has an M1 processor
# RUN apk --no-cache add --virtual builds-deps build-base python
RUN yarn && yarn cache clean;
EXPOSE 3000
CMD [ "yarn", "dev" ]