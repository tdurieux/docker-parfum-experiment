FROM ezcater-production.jfrog.io/ruby:90790156c4
RUN mkdir /usr/src/gem && rm -rf /usr/src/gem
WORKDIR /usr/src/gem
ADD . /usr/src/gem
