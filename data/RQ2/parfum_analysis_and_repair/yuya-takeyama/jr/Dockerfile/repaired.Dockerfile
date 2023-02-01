FROM ruby:3.1-alpine

COPY . /app
WORKDIR /app
RUN apk --update --no-cache add build-base git && \
  bundle install --without development

ENTRYPOINT ["bundle", "exec", "jr"]
