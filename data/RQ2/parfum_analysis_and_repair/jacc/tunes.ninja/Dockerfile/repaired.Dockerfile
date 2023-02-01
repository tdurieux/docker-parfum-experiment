FROM node:latest
WORKDIR /app
ADD package.json .
ADD yarn.lock .
RUN yarn && yarn cache clean;
ADD prisma .
RUN yarn generate && yarn cache clean;
ADD . .
RUN yarn build && yarn cache clean;
