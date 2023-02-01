# Use debian as it matches a Raspbian environment
FROM debian:stretch

LABEL maintainer="code@reef-pi.com"

RUN apt-get update -y && \
    apt-get install --no-install-recommends curl build-essential git mercurial ruby-dev -y && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    npm install -g npm && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;
RUN curl -f -L https://go.dev/dl/go1.13.15.linux-amd64.tar.gz > /tmp/go1.13.15.linux-amd64.tar.gz && \
    tar xvzf /tmp/go1.13.15.linux-amd64.tar.gz -C /usr/local && rm /tmp/go1.13.15.linux-amd64.tar.gz

RUN npm install --global yarn && npm cache clean --force;

RUN gem install bundler

ENV GOPATH=/gopath
ENV PATH="/usr/local/go/bin:${GOPATH}/bin:${PATH}"

RUN mkdir -p /gopath/src/github.com/reef-pi/reef-pi
WORKDIR /gopath/src/github.com/reef-pi/reef-pi

COPY Gemfile Gemfile.lock /gopath/src/github.com/reef-pi/reef-pi/
RUN bundle install

# Bootstrap dependencies
COPY Makefile package.json /gopath/src/github.com/reef-pi/reef-pi/
RUN npm install && npm cache clean --force;

COPY controller/ /gopath/src/github.com/reef-pi/reef-pi/controller/
RUN make go-get

# Copy the rest of the code base for building
COPY . /gopath/src/github.com/reef-pi/reef-pi/
