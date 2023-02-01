FROM ruby:2.2.0
RUN apt-get update -yqq
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y npm && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libpq-dev && rm -rf /var/lib/apt/lists/*;
RUN mkdir /mwdc
WORKDIR /mwdc
ADD Gemfile /mwdc/Gemfile
ADD Gemfile.lock /mwdc/Gemfile.lock
RUN bundle install
ADD . /mwdc
