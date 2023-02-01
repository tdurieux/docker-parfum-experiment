FROM ruby
LABEL maintainer=mike.dalessio@gmail.com

RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install --global ansi-to-html markdown-toc && npm cache clean --force;

COPY Gemfile*                          calendar-assistant/
RUN gem install bundler

COPY calendar-assistant.gemspec        calendar-assistant/
COPY lib/calendar_assistant/version.rb calendar-assistant/lib/calendar_assistant/

RUN cd calendar-assistant && bundle install
