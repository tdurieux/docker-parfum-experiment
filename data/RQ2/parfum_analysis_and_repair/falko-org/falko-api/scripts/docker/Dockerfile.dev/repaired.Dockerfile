FROM ruby:2.4.1

MAINTAINER alaxallves@gmail.com

RUN apt-get update -qq \
    && apt-get install --no-install-recommends -y build-essential libpq-dev \
    && curl -f -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install --no-install-recommends -y nodejs \
    && apt-get update && apt-get install --no-install-recommends -y curl apt-transport-https wget \
    && curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install --no-install-recommends -y yarn postgresql-client && rm -rf /var/lib/apt/lists/*;

ENV BUNDLE_PATH /bundle-cache

WORKDIR /Falko-2017.2-BackEnd

COPY . /Falko-2017.2-BackEnd

CMD ["bundle", "exec", "rails", "s", "-p", "3000" "-b", "0.0.0.0"]
