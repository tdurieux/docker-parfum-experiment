FROM ubuntu:trusty
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>
RUN apt-get -yq update && apt-get -yq upgrade \
  && apt-get -yq --no-install-recommends install curl gcc make libssl-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*;
# Ruby
WORKDIR /usr/local/src
RUN curl -f -sSL https://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.3.tar.gz | tar zx \
  && cd /usr/local/src/ruby-2.1.3 \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install \
  && rm -rf /usr/local/src/ruby-2.1.3
ENV GEM_HOME /usr/local/gems
RUN gem install bundler --no-ri --no-rdoc
RUN gem install ZenTest --no-ri --no-rdoc
RUN gem install rspec-autotest --no-ri --no-rdoc
RUN addgroup gems \
  && chgrp -R gems /usr/local/gems \
  && chmod -R g+w /usr/local/gems \
  && find /usr/local/gems -type d -exec chmod g+s {} \;
VOLUME /usr/local/gems
