FROM node:16-slim as api-builder
ENV TZ Asia/Shanghai
WORKDIR /app/tellery-api
COPY packages/api/package.json .
COPY packages/api/yarn.lock .
RUN yarn install && yarn cache clean;
COPY packages/api .
COPY packages/protobufs /app/protobufs
RUN npm run compile

FROM node:16-alpine as web-builder
WORKDIR /app/tellery-web
COPY packages/web/package.json .
COPY packages/web/yarn.lock .
RUN yarn install --frozen-lockfile && yarn cache clean;
COPY packages/web .
RUN yarn build

FROM node:16-alpine
WORKDIR /tellery
COPY --from=api-builder /app/tellery-api/package.json .
COPY --from=api-builder /app/tellery-api/yarn.lock .
RUN yarn install --production && yarn cache clean;
COPY --from=api-builder /app/tellery-api/dist dist
COPY --from=api-builder /app/tellery-api/config config
COPY --from=web-builder /app/tellery-web/dist dist/src/assets/web
ENTRYPOINT ["npm", "run"]
CMD ["start"]
