FROM shingara/ruby-2.0.0
MAINTAINER Cyril Mougel "cyril.mougel@gmail.com"

# need because git clone on Gemfile
RUN apt-get -y --no-install-recommends -q install git-core && rm -rf /var/lib/apt/lists/*;

## Gem needed by some gems
RUN apt-get -y --no-install-recommends -q install libxml2 libxml2-dev libxslt-dev libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*;


RUN wget -O errbit-0.1.0.tar.gz https://github.com/errbit/errbit/archive/v0.1.0.tar.gz
RUN tar -xzvf errbit-0.1.0.tar.gz && rm errbit-0.1.0.tar.gz
RUN gem install bundler --no-ri --no-rdoc
RUN cd errbit-0.1.0 && bundle install --deployment --without test development
