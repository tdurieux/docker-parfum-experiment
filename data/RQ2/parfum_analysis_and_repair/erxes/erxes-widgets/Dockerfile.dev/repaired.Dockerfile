FROM erxes/runner
WORKDIR /erxes-widgets
COPY yarn.lock package.json ./
RUN yarn install && yarn cache clean;
CMD ["yarn", "dev"]
