From node:14-slim
WORKDIR /app/
COPY . .
RUN yarn && yarn cache clean;
CMD yarn sync-db synchronize && yarn start
