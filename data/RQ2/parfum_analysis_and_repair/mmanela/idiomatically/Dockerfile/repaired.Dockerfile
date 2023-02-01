FROM appsvc/node:12-lts

LABEL NAME=idiom

ENV REACT_APP_SERVER https://idiomatically.net

# Setup app
COPY lib/package*.json ./
COPY lib/yarn.lock ./
RUN yarn install --production=false && yarn cache clean;

# Copy contents
COPY lib/ .

# Build Client
RUN yarn client:build

# Start Server
ENV PORT 80
EXPOSE 80
CMD ["yarn","server:prod"]