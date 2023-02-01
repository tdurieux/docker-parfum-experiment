FROM jruby:latest

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y locales && \
    apt-get install --no-install-recommends -y build-essential libjson-c-dev && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*;
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen

WORKDIR /usr/src/app/

RUN gem install bundler -v '~> 2'
COPY Gemfile* activegraph.gemspec ./
COPY lib/active_graph/version.rb ./lib/active_graph/
RUN bundle install

ADD . ./

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8
