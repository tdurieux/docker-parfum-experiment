FROM erxes/runner
WORKDIR /erxes-engages-email-sender
COPY yarn.lock package.json ./
RUN yarn install && yarn cache clean;
CMD ["yarn", "dev"]
