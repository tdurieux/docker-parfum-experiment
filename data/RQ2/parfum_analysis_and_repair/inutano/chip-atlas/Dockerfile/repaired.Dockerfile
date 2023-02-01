# Docker container for chip-atlas dev env
FROM ruby:2.6.5-slim
RUN apt-get update -y && apt-get install --no-install-recommends -y libffi-dev build-essential libpq-dev libsqlite3-dev && rm -rf /var/lib/apt/lists/*;
COPY . /app
WORKDIR /app
RUN bundle install
CMD ["bundle", "exe", "rackup", "--host", "0.0.0.0", "-p", "9292"]
