FROM ruby:2.4

RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash - && \
    curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install --no-install-recommends -y yarn nodejs unzip && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y ffmpeg python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade youtube_dl

RUN apt-get install -y --no-install-recommends shared-mime-info && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
COPY Gemfile* ./
RUN bundle install --deployment --without test development --jobs=4

COPY . ./

ENV DATABASE_URL=sqlite3:///db/production.sqlite3

ENV RAILS_ENV=production
RUN bundle exec rake webpacker:yarn_install
RUN bundle exec rake assets:precompile

ENV RAILS_LOG_TO_STDOUT=true
ENV MAX_EPISODES_TO_STORE=50

VOLUME /db
VOLUME /uploads
VOLUME /app/tmp/youtube

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["web"]
