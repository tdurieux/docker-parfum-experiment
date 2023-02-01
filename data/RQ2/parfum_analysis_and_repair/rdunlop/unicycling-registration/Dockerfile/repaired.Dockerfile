FROM ruby:2.6.6

# Install NodeJS based on https://github.com/nodesource/distributions#installation-instructions
RUN apt-get update && apt-get install --no-install-recommends --yes nodejs && rm -rf /var/lib/apt/lists/*; # Actually install NODEJS
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash


RUN mkdir /app

WORKDIR /app
ENV BUNDLE_PATH /gems

ENTRYPOINT ["./docker-entrypoint.sh"]
