FROM ruby:2.5

ARG uid

RUN apt-get update && apt-get install --no-install-recommends -y postgresql-client && rm -rf /var/lib/apt/lists/*;

RUN useradd -M -u $uid mtools
USER mtools
