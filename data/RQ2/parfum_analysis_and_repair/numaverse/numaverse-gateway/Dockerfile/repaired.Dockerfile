FROM ruby:2.3.3
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
# RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq
RUN apt-get install --no-install-recommends -yqq apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yqq curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq
RUN apt-get install --no-install-recommends -y build-essential postgresql postgresql-contrib libpq-dev cmake nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yqq yarn && rm -rf /var/lib/apt/lists/*;
RUN mkdir /numa
WORKDIR /numa

ENV BUNDLE_PATH /box

COPY Gemfile /numa/Gemfile
COPY Gemfile.lock /numa/Gemfile.lock

ADD package.json yarn.lock /numa/
RUN yarn

COPY . /numa

EXPOSE 3000
ENTRYPOINT ["bundle", "exec"]
CMD ["rails", "server", "-b", "0.0.0.0"]