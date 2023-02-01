FROM ruby:2.1.10

RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y imagemagick && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

WORKDIR /tmp
COPY Gemfile /tmp
COPY Gemfile.lock /tmp

RUN bundle install

WORKDIR /app
COPY . /app

EXPOSE 3000

CMD ["bash"]