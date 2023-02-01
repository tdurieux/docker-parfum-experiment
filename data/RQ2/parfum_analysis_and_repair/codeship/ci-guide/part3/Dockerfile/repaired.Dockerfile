# base on latest ruby base image
FROM ruby:2.5.0

# install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y build-essential libpq-dev nodejs apt-utils && rm -rf /var/lib/apt/lists/*;

# declare /app as working directory of image
WORKDIR /app

# copy over Gemfile and Gemfile.lock to image's working directory, then run `bundle install`
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 20 --retry 5

# copy all remaining files/folders in project directory to the container
COPY . /app
