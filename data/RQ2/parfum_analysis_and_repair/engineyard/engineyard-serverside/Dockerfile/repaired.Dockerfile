FROM ruby:3.0
MAINTAINER dwalters@engineyard.com

RUN apt-get update && apt-get install --no-install-recommends -y \
  build-essential \
  rsync \
  wamerican \
  nodejs \
  vim && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /app
WORKDIR /app

COPY . ./
#RUN gem install bundler && bundle install
RUN bundle install

CMD ["bash"]
