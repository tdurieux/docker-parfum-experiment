FROM circleci/ruby:2.7.2

RUN sudo apt-get update
RUN sudo apt-get install -y --no-install-recommends docker && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
COPY . .

RUN bundle install
