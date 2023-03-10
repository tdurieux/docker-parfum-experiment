FROM ruby:latest

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y locales && \
    apt-get install --no-install-recommends -y build-essential libjson-c-dev && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*;
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen

RUN mkdir /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app/

COPY Gemfile* ./
COPY neo4j-core.gemspec ./
COPY lib/neo4j-core/version.rb ./lib/neo4j-core/
RUN bundle

ADD . ./

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

