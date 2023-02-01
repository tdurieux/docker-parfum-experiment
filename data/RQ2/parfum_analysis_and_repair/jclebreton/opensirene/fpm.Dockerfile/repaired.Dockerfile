FROM debian:8
RUN apt-get update && apt-get install --no-install-recommends -y ruby ruby-dev build-essential && rm -rf /var/lib/apt/lists/*;
RUN gem install fpm
WORKDIR /packaging
