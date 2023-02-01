FROM amazeeio/node:14-builder as builder

# Build source files.
COPY . /app/
RUN yarn && yarn cache clean;
RUN yarn build && yarn cache clean;
RUN yarn build:docs && yarn cache clean;

# Build static files.
FROM amazeeio/node:14
COPY --from=builder /app/docs /app

RUN yarn && yarn cache clean;
RUN yarn generate && yarn cache clean;

ENV HOST 0.0.0.0
EXPOSE 3000

CMD ["yarn", "start"]
