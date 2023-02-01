FROM node:16-bullseye
WORKDIR /engine/
COPY . /engine/
ARG SENTRY_RELEASE
ENV SENTRY_RELEASE=$SENTRY_RELEASE
ARG IASQL_ENV
ENV IASQL_ENV=$IASQL_ENV
RUN apt update && apt install --no-install-recommends postgresql-client-13 -y && rm -rf /var/lib/apt/lists/*;
RUN apt upgrade -y

RUN yarn && yarn cache clean;
RUN yarn build && yarn cache clean;
EXPOSE 8088
CMD yarn start