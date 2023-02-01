FROM node:current-buster-slim
WORKDIR /app
COPY . /app
RUN apt-get update && apt-get install --no-install-recommends -y python3 git build-essential && npm install && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

FROM node:current-buster-slim
WORKDIR /app
COPY --from=0 /app /app
RUN yarn && yarn cache clean;
ENV DB_ROOT=/storage \
    ORIGIN=http://localhost:8000
CMD ["yarn", "start"]