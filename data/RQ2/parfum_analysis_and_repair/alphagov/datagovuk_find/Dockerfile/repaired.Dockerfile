FROM ruby:2.7.5

WORKDIR /srv/app/datagovuk_find

RUN apt-get update
RUN apt-get install --no-install-recommends -y nodejs postgresql postgresql-contrib && rm -rf /var/lib/apt/lists/*;

# to install yarn we have to remove cmdtest
RUN apt-get remove -y cmdtest
RUN apt autoremove -y
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install --no-install-recommends -y yarn && rm -rf /var/lib/apt/lists/*;

COPY ./ /srv/app/datagovuk_find

RUN gem install bundler --conservative && \
    bundle install && \
    bin/yarn
