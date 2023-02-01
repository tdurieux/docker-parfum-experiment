FROM ruby
MAINTAINER Frederic Branczyk <fbranczyk@gmail.com>
RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y libcurl4-gnutls-dev make && rm -rf /var/lib/apt/lists/*;
RUN gem install fluentd -v "~>0.12.15"
RUN gem install fluent-plugin-amqp2
RUN mkdir /etc/fluent
WORKDIR /etc/fluent
COPY . /etc/fluent
ENTRYPOINT ["./docker-entrypoint.sh"]
