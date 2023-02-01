FROM ruby:2.6.5
WORKDIR /opt/app

RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

# for postgres
RUN apt-get install --no-install-recommends -y libpq-dev && rm -rf /var/lib/apt/lists/*;

# for nokogiri
RUN apt-get install --no-install-recommends -y libxml2-dev libxslt1-dev && rm -rf /var/lib/apt/lists/*;

# for capybara-webkit
RUN apt-get install --no-install-recommends -y libqt4-webkit libqt4-dev xvfb && rm -rf /var/lib/apt/lists/*;

# for a JS runtime
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

COPY Gemfile* ./
RUN gem install bundler:1.17.2
