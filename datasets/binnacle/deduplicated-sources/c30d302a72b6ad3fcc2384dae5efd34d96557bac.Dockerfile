ARG RUBY_VERSION
FROM ruby:$RUBY_VERSION

RUN apt-get update && apt-get install less -y
RUN groupadd --gid 1000 ruby && useradd --uid 1000 --gid ruby --shell /bin/bash --create-home ruby
RUN mkdir /app /vendor && chown ruby:ruby /app /vendor

ENV LANG=C.UTF-8 \
  BUNDLE_PATH=/vendor/bundle/$RUBY_VERSION \
  BUNDLE_JOBS=4

ENV ENTRYKIT_VERSION 0.4.0

RUN wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && mv entrykit /bin/entrykit \
  && chmod +x /bin/entrykit \
  && entrykit --symlink

USER ruby
WORKDIR /app

ENTRYPOINT ["prehook", "bin/setup", "--"]
