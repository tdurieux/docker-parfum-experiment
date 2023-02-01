FROM ruby:3.0

ENV PORT=80
ENV RACK_ENV=production

EXPOSE ${PORT}
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

RUN apt-get update

RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:libreoffice/ppa
RUN apt-get install -y --no-install-recommends libreoffice-writer && rm -rf /var/lib/apt/lists/*;

COPY Gemfile Gemfile.lock ./
RUN bundle install --without="development test"

COPY public/ ./public/
COPY views/ ./views/
COPY docs/ ./docs/
COPY config.ru puma.rb server.rb Procfile ./

CMD ["bundle", "exec", "puma", "-C", "puma.rb"]
