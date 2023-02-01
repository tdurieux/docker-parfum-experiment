ARG image
FROM $image
COPY . .
RUN yarn install && yarn cache clean;
RUN yarn build
RUN yarn lint