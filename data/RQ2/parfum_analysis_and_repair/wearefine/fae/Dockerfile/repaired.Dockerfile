FROM ruby:2.3.1

RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN apt-get update -y && apt-get install --no-install-recommends -y \
      libqt5webkit5-dev \
      qt5-default \
      xvfb && rm -rf /var/lib/apt/lists/*;

ENV app /app
ENV BUNDLE_PATH /gems
ENV GEM_HOME /gems

COPY Gemfile* $app/

ENV PATH="$PATH:$BUNDLE_PATH/bin"

COPY . $app/
