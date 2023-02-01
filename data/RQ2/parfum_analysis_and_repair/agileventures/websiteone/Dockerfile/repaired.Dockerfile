FROM ruby:2.6.3

RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential \
    libpq-dev nodejs qt5-default libqt5webkit5-dev dos2unix \
    gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x && rm -rf /var/lib/apt/lists/*;


RUN mkdir /WebsiteOne
WORKDIR /WebsiteOne

COPY Gemfile /WebsiteOne/Gemfile
COPY Gemfile.lock /WebsiteOne/Gemfile.lock

COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"

RUN bundle install

COPY package.json /WebsiteOne/package.json
COPY package-lock.json /WebsiteOne/package-lock.json
COPY scripts /WebsiteOne/scripts
COPY vendor/assets/javascripts /WebsiteOne/assets/javascripts

RUN dos2unix scripts/copy_javascript_dependencies.js
RUN npm install --unsafe-perm && npm cache clean --force;
RUN npm install -g phantomjs-prebuilt --unsafe-perm && npm cache clean --force;

COPY . /WebsiteOne
