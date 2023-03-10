FROM ruby:3.1-alpine

WORKDIR /usr/src/app

COPY . ./

RUN apk add --no-cache build-base {{#deps}}{{{.}}}{{/deps}}

RUN bundle config set without 'development test'
RUN bundle install

{{#environment}}
ENV {{{.}}}
{{/environment}}

{{#command}}
  CMD {{{command}}}
{{/command}}

{{^command}}
  CMD bundle exec puma -p 3000 -e production -w $(nproc)
{{/command}}
