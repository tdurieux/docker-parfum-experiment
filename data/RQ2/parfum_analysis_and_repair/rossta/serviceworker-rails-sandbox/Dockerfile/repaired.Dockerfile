FROM ruby:2.3.1

RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

# for postgres
RUN apt-get install --no-install-recommends -y libpq-dev && rm -rf /var/lib/apt/lists/*;

# for nokogiri
RUN apt-get install --no-install-recommends -y libxml2-dev libxslt1-dev && rm -rf /var/lib/apt/lists/*;

# for capybara-webkit
RUN apt-get install --no-install-recommends -y libqt4-webkit libqt4-dev xvfb && rm -rf /var/lib/apt/lists/*;

# for a JS runtime
RUN apt-get install --no-install-recommends -y nodejs npm nodejs-legacy && rm -rf /var/lib/apt/lists/*;

ENV APP_HOME /app
RUN mkdir -p $APP_HOME

# use changes to package.json to force Docker not to use the cache
# when we change our application's nodejs dependencies:
# ADD package.json /tmp/package.json
# RUN cd /tmp && npm install
# RUN cp -a /tmp/node_modules $APP_HOME

WORKDIR $APP_HOME

ENV BUNDLE_PATH /gems
ENV NODE_PATH /node

ADD . $APP_HOME
