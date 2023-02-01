FROM public.ecr.aws/docker/library/node:16 as assets-builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install && npm cache clean --force;
COPY webpack.config.js ./
COPY app/javascript ./app/javascript
RUN NODE_ENV=production npm run webpack

FROM public.ecr.aws/docker/library/ruby:3.0.0-slim-buster
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential libpq-dev default-libmysqlclient-dev && rm -rf /var/lib/apt/lists/*;

COPY Gemfile Gemfile.lock /tmp/
RUN cd /tmp && bundle install -j5 --deployment --path /gems --without test

WORKDIR /app
COPY . ./

COPY --from=assets-builder /app/public/packs ./public/packs

CMD ["./bin/docker_start.sh"]
