# Dockerfile for running the application in a CI environment.
FROM ruby:3.0.3

RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN curl -f -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && echo "deb https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
RUN apt-get update -qqy && apt-get install --no-install-recommends -qqyy google-chrome-stable yarn nodejs postgresql postgresql-client && rm -rf /var/lib/apt/lists/*;
