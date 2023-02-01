FROM ruby:2.2.0
MAINTAINER Nguyen Sy Thanh Son
RUN apt-get update && apt-get install --no-install-recommends -y libcurl4-gnutls-dev make && rm -rf /var/lib/apt/lists/*;
RUN gem install fluentd -v "~>0.12.3"
RUN mkdir /etc/fluent

RUN /usr/local/bin/gem install fluent-plugin-elasticsearch fluent-plugin-concat
ADD fluent.conf /etc/fluent/
ENTRYPOINT ["/usr/local/bundle/bin/fluentd", "-c", "/etc/fluent/fluent.conf"]
