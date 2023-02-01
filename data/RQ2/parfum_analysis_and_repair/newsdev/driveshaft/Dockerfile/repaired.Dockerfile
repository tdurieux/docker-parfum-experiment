FROM ruby:2.5-alpine

# Configure bundler
RUN \
  bundle config --global frozen 1 && \
  bundle config --global build.nokogiri --use-system-libraries

# Set the working directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# Install gems and npm modules
COPY Gemfile Gemfile.lock package.json /usr/src/app/
RUN apk --update --no-cache add --virtual .build-deps \
        build-base g++ make \
      && apk add --no-cache yarn --update-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
      && apk add --no-cache \
        libxml2 libxslt-dev git \
      && bundle install --jobs `grep -c '^processor' /proc/cpuinfo` \
      && apk del .build-deps

# Install npm packages
COPY package.json /usr/src/app/
RUN yarn install --ignore-scripts && yarn cache clean;

# Copy the rest of the application source
COPY . /usr/src/app

# Run the server
EXPOSE 3000
CMD ["puma", "-t", "16:16", "-p", "3000"]
