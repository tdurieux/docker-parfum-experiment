FROM ruby:2.2

RUN apt-get update && apt-get install --no-install-recommends -y percona-toolkit && rm -rf /var/lib/apt/lists/*;

COPY . /code/

WORKDIR /code
