FROM phusion/baseimage

EXPOSE 5000
EXPOSE 35729

ENV NODE_ENV=development
ENV STATIC_ASSETS_URL=.

RUN apt-get update && \
  apt-get install --no-install-recommends -y curl && \
  curl -f -sL https://deb.nodesource.com/setup_8.x | bash - && \
  apt-get install --no-install-recommends -y \
  build-essential \
  git \
  nodejs \
  ruby && rm -rf /var/lib/apt/lists/*;

RUN gem install foreman

RUN mkdir -p /src/app
WORKDIR /src/app

COPY . .

RUN npm install && npm cache clean --force;
RUN ./node_modules/.bin/bower --allow-root --config.interactive=false install

CMD ["foreman", "start"]
