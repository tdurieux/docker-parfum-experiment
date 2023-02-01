FROM node:16-alpine3.14

ENV PORT "$PORT"
ENV NODE_ENV "production"

WORKDIR /app

COPY . /app

RUN apk add --no-cache curl
RUN pwd
RUN rm -rf /app/*.tsbuildinfo
RUN rm -rf /app/lib
RUN yarn global add typescript && yarn cache clean;

RUN yarn && yarn cache clean;
RUN yarn run tsc && yarn cache clean;

EXPOSE ${PORT}

ENTRYPOINT [ "node" ]
CMD ["--trace-warnings", "/app/lib/index.js"]
