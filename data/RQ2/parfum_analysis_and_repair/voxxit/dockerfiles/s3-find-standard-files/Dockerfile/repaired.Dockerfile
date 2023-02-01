FROM ruby:2.4

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY *.rb /usr/src/app/

ENTRYPOINT ["./s3-find-standard-files.rb"]
