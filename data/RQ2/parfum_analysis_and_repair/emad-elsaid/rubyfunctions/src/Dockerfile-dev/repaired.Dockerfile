FROM ruby:2.6.3-slim
ENV LANG=C.UTF-8
ENV RAILS_ENV=development
RUN apt update && apt install -qq -y build-essential nodejs libpq-dev postgresql-client npm --fix-missing --no-install-recommends && rm -rf /var/lib/apt/lists/*;
RUN gem install bundler
RUN npm install --global yarn && npm cache clean --force;

ENV app /app
RUN mkdir -p $app
WORKDIR $app

ENV BUNDLE_PATH /gems
