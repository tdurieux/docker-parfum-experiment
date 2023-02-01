FROM techbureau/catapult-tools:gcc-0.9.6.3
RUN apt update
RUN apt install --no-install-recommends -y ruby && rm -rf /var/lib/apt/lists/*;
# for debug
RUN apt install --no-install-recommends -y ruby-dev make g++ && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/app

COPY catapult-bootstrap.gemspec /usr/app/
COPY Gemfile /usr/app/
COPY Gemfile.lock /usr/app/
ADD lib /usr/app/lib
ADD bin /usr/app/bin
ADD spec /usr/app/spec

RUN gem install bundler -v "$(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -n 1)"
#ARG BUNDLE_GITHUB__COM
RUN bundle install
# when dbugging this will be mounted
RUN rm -rf /usr/app/*


