FROM erxes/runner
WORKDIR /erxes-api
COPY yarn.lock package.json ./
RUN yarn install && yarn cache clean;
CMD ["yarn", "dev"]


