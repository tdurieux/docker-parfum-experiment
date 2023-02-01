FROM node:12 as base
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ENV PORT 3122
EXPOSE 3122

FROM base as production_build
ENV NODE_ENV=production
COPY . .
RUN npm ci --production
RUN npm run prod-build

FROM node:12-alpine as production
ARG BUILD_REVISION=local-build
ARG BUILD_SMTP_ID
ENV SMTP_ID=${BUILD_SMTP_ID}
ARG BUILD_SMTP_PWD
ENV SMTP_PWD=${BUILD_SMTP_PWD}
ENV REVISION=${BUILD_REVISION}
ENV NODE_ENV=production
COPY --from=production_build /usr/src/app /voluntarily
WORKDIR /voluntarily
CMD ["npm", "start" ]

FROM base as development
ENV NODE_ENV=development
ENV MONGOMS_DOWNLOAD_MIRROR="http://downloads.mongodb.org"
ENV MONGOMS_VERSION="v4.0-latest"
COPY . ./
RUN npm install
CMD ["npm", "run", "dev"]