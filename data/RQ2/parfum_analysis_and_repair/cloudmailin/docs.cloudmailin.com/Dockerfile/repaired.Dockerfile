FROM ruby:2.7

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt-get update -qq && apt-get install --no-install-recommends -qq -y build-essential nodejs libjq-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

ENV RUBYJQ_USE_SYSTEM_LIBRARIES=yes
ENV BUNDLE_BUILD__NOKOGIRI: "--use-system-libraries"

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install -j 8
COPY . /app

CMD ["nanoc",  "-v"]
