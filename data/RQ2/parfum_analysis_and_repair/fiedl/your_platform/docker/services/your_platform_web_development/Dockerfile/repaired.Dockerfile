FROM ruby:2.7.1

ENV RAILS_ENV=development

# Install requirements for ruby gems.
RUN apt-get update && apt-get install --no-install-recommends -y aptitude && rm -rf /var/lib/apt/lists/*;
RUN aptitude install -y libssl-dev g++ libxml2 libxslt-dev libreadline-dev libicu-dev imagemagick libmagick-dev
RUN gem install bundler

# Install nodejs.
RUN aptitude install -y build-essential libssl-dev
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash
RUN aptitude install -y nodejs
RUN node --version
RUN npm i -g yarn && npm cache clean --force;

# Install helper packages.
RUN aptitude install -y pwgen

WORKDIR /app
CMD ["script/start"]