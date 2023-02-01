FROM ruby:2.4.0

RUN apt-get update \
    && apt-get -y --no-install-recommends install curl \
    && curl -f -sL https://deb.nodesource.com/setup_8.x | bash && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends \
        postgresql-client \
    && apt-get install --no-install-recommends -y build-essential patch libpq-dev ruby-dev nodejs zlib1g-dev liblzma-dev \
    && rm -rf /var/lib/apt/lists/*
   RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN gem update --system && rm -rf /root/.gem;

RUN gem install bundler foreman

RUN mkdir /var/elovation
RUN mkdir /var/elovation/public
RUN mkdir /var/elovation/public/assets

COPY Gemfile /var/elovation/
COPY Gemfile.lock /var/elovation/

RUN mkdir -p /var/bundle

# Add application source
WORKDIR /var/elovation

ADD . /var/elovation

ADD config/database.yml.docker /var/elovation/config/database.yml
COPY ./web-entrypoint.sh /
RUN ["chmod", "+x", "/web-entrypoint.sh"]
RUN npm install yarn -g && npm cache clean --force;

ENV RAILS_ENV production
ENV RAILS_LOG_TO_STDOUT yes
ENV RAILS_SERVE_STATIC_FILES yes

EXPOSE 5000

ENTRYPOINT ["/web-entrypoint.sh"]

CMD ["foreman", "start"]

