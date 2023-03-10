FROM debian:wheezy

RUN apt-get update && apt-get install --no-install-recommends -y ruby-dev build-essential git wget && rm -rf /var/lib/apt/lists/*;
RUN gem install --no-ri --no-rdoc bundler
RUN useradd script && mkdir -p /home/script

ADD script/              /home/script/

RUN chown -R script:script /home/script

USER script
WORKDIR /home/script


RUN ls -laR

RUN bundle install --path gems

CMD []
ENTRYPOINT ["/home/script/travis-run-script"]
