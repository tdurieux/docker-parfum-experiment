FROM ruby:2.4.1
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN mkdir /lookingglass
WORKDIR /lookingglass
ADD * /lookingglass/
RUN bundle install
ADD . /lookingglass