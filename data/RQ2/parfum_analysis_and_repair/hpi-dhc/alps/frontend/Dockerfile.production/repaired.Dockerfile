# Build
FROM node:12-alpine as build

COPY . /app
WORKDIR /app

ARG REACT_APP_BACKEND_URL
ENV REACT_APP_BACKEND_URL ${REACT_APP_BACKEND_URL}

RUN yarn install && \
    yarn build && yarn cache clean;

# Production
FROM nginx as runtime

EXPOSE 80

COPY --from=build /app/build /var/www/localhost/htdocs/frontend
