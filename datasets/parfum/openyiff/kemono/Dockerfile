FROM node:current-buster-slim
WORKDIR /app
COPY . /app
RUN apt-get update && apt-get install -y python3 git build-essential && npm install

FROM node:current-buster-slim
WORKDIR /app
COPY --from=0 /app /app
RUN yarn
ENV DB_ROOT=/storage \
    ORIGIN=http://localhost:8000
CMD ["yarn", "start"]