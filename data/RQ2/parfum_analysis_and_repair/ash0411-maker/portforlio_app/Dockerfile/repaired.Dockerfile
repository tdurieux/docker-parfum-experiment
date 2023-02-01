FROM ruby:2.6

# install package to docker container
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential libpq-dev \
    && apt-get install -y --no-install-recommends apt-transport-https \
    && curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install --no-install-recommends -y yarn \
    && curl -f -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install --no-install-recommends -y nodejs mariadb-client \
    && mkdir /FANTRA && rm -rf /var/lib/apt/lists/*;

WORKDIR /FANTRA
COPY Gemfile /FANTRA/Gemfile
COPY Gemfile.lock /FANTRA/Gemfile.lock

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000