FROM ruby:2.5.7-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq
RUN apt-get install --no-install-recommends -y \
    curl \
    gnupg2 && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -

RUN apt-get install --no-install-recommends -y \
	build-essential \
	nodejs \
	libpq-dev \
	libqt5webkit5-dev \
	qt5-default \
	git \
	xvfb && \
    gem install bundler && rm -rf /var/lib/apt/lists/*;

# Copy project src to container
COPY ./Gemfile /app/
COPY ./Gemfile.lock /app/

# Set /app as workdir
WORKDIR /app

# Install dependencies
RUN bundle install
