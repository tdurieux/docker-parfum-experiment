## Building image ##
FROM ruby:3.0.3-slim-bullseye AS builder
WORKDIR /app
# install build dependencies
RUN apt update && apt install --no-install-recommends make gcc g++ libffi-dev nodejs git -y && rm -rf /var/lib/apt/lists/*;
COPY . .
RUN bundle install
EXPOSE 4567
CMD ["bin/middleman", "serve"]