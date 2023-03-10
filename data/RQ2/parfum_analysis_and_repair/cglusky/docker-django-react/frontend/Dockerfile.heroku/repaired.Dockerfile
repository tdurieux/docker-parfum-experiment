ARG VERSION=10.15.3-alpine

FROM node:${VERSION} as builder

ARG REACT_APP_API_URL

WORKDIR /code

COPY . /code/
RUN yarn install --check-files \
  && yarn build && yarn cache clean;


FROM node:${VERSION} as final

WORKDIR /app
COPY --from=builder /code/build /app

RUN yarn global add serve