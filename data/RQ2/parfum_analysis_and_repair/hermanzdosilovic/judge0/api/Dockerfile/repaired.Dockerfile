FROM hermanzdosilovic/judge0-base

RUN apt-get update && apt-get install --no-install-recommends -y \
  libpq-dev \
  nodejs-legacy \
  npm && rm -rf /var/lib/apt/lists/*;

RUN echo "gem: --no-document" > /root/.gemrc && gem install \
  rails:5.0 \
  bundler \
  pg && \
  npm install -g aglio && npm cache clean --force;

EXPOSE 3000

COPY . /usr/src/api
WORKDIR /usr/src/api
RUN bundle && \
  aglio -i docs/API.md -o public/docs.html

CMD rm -f tmp/pids/server.pid && \
  rails db:create db:migrate db:seed && \
  rails s -b 0.0.0.0
