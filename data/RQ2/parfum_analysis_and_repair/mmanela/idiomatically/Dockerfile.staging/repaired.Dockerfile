FROM appsvc/node:12-lts

LABEL NAME=idiom

ENV REACT_APP_SERVER http://127.0.0.1:8000

# Setup app
COPY lib/package*.json ./
COPY lib/yarn.lock ./
RUN yarn install --production=false && yarn cache clean;

# Copy contents
COPY lib/ .

# Build Client
RUN yarn client:build:staging

# Start Server
ENV PORT 8000
EXPOSE 8000
CMD ["yarn","server:start:staging"]