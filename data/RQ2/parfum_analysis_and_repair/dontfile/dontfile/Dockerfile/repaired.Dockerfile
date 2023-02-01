FROM ruby:2.6.6

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential \
                       libpq-dev \
                       nodejs \
                       postgresql && rm -rf /var/lib/apt/lists/*;

WORKDIR /dontfile

COPY . /dontfile

ENTRYPOINT ["./startup.sh"]
