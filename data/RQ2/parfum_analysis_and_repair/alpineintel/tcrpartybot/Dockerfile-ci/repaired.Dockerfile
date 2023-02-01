FROM ruby:2.4.0

RUN echo "deb http://toolbelt.heroku.com/ubuntu ./" > /etc/apt/sources.list.d/heroku.list
RUN wget -O- https://toolbelt.heroku.com/apt/release.key | apt-key add -
RUN apt-get update && apt-get install --no-install-recommends -y heroku-toolbelt && rm -rf /var/lib/apt/lists/*;
RUN gem install dpl
