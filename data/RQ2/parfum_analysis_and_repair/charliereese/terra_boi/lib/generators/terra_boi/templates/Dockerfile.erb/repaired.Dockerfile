FROM ruby:<%= class_options[:ruby_version] %>

RUN apt-get update -qq && apt-get install --no-install-recommends -y npm build-essential cron && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash - && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install yarn -g && npm cache clean --force;

ENV APP_HOME /<%= application_name %>
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install
RUN yarn install --check-files && yarn cache clean;

ADD . $APP_HOME

RUN RAILS_ENV=production rails assets:precompile
RUN service cron start

EXPOSE 3000

ENTRYPOINT rake db:migrate && bin/rails server --port 3000 -b 0.0.0.0