FROM jruby:latest

RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

WORKDIR /app/

COPY . .
ARG BUNDLE_VERSION
ARG GEMSETS
RUN gem install bundler -v $BUNDLE_VERSION
RUN bundle _${BUNDLE_VERSION}_ install --with "$GEMSETS" --binstubs

CMD ["bundle", "exec", "./bin/rake", "spec"]
