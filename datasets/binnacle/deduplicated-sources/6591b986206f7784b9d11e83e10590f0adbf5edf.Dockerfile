FROM ruby:2.4.6-alpine as Builder

ENV RAILS_ROOT /var/www/heimdall

# Deploy production server to container
ENV RAILS_ENV=production

RUN mkdir -p $RAILS_ROOT

WORKDIR $RAILS_ROOT

COPY Gemfile Gemfile.lock ./

# Ensure we never install docs
RUN echo "gem: --no-rdoc --no-ri" >> ~/.gemrc

RUN apk --no-cache --update add build-base \
    libc-dev libxml2-dev imagemagick6 imagemagick6-dev pkgconf nodejs

RUN gem install bundler && bundle install --without development test -j4 --retry 3

COPY . .

# precompile is only necessary for production builds
RUN sh -c "RAILS_ENV=$RAILS_ENV SECRET_KEY_BASE=xxx bundle exec rake assets:precompile"

RUN rm -rf tmp/cache spec /usr/local/bundle/cache && find /usr/local/bundle/gems/ -name "*.c" -delete && \
    find /usr/local/bundle/gems/ -name "*.o"

# The container above is only used for building. Once the source code is built we copy
# the required artifacts out of the build above and put them in a clean container.
# This allows our image size to be much smaller.
FROM ruby:2.4.6-alpine

ENV RAILS_ROOT /var/www/heimdall

RUN mkdir -p $RAILS_ROOT

WORKDIR $RAILS_ROOT

COPY --from=Builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=Builder $RAILS_ROOT $RAILS_ROOT

RUN apk --no-cache --update add nodejs imagemagick6 && gem install bundler

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-p", "3000", "-b", "0.0.0.0"]
