FROM ruby:2.5.1

RUN apt update && apt install --no-install-recommends -y nodejs=4.8.2~dfsg-1 && rm -rf /var/lib/apt/lists/*;

COPY Gemfile Gemfile.lock demo/
WORKDIR demo
RUN bundle install
