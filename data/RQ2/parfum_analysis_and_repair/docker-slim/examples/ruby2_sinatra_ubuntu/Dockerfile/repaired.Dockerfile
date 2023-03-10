FROM ubuntu:14.04

RUN apt-get update && \
		apt-get -y --no-install-recommends install software-properties-common build-essential && \
		apt-add-repository ppa:brightbox/ruby-ng && \
		apt-get update && \
		apt-get -y --no-install-recommends install ruby2.5 ruby2.5-dev && \
		gem install bundler -v 1.16 && \
		mkdir -p /opt/my/service && rm -rf /var/lib/apt/lists/*;

COPY service /opt/my/service

WORKDIR /opt/my/service

RUN bundle install

EXPOSE 1300
ENTRYPOINT ["ruby","/opt/my/service/server.rb"]


