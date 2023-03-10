# Ubuntu/precise is the main distribution
FROM ubuntu:trusty

# add chris-lea repo
RUN rm -rvf /var/lib/apt/lists/*
RUN apt-get update
RUN apt-get install --no-install-recommends -y libssl1.0.0 openssl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y software-properties-common python-software-properties libicu-dev && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:chris-lea/node.js

# add wget and nodejs
RUN apt-get update
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# add logstash sources list and install it
# RUN apt-get install --no-install-recommends -y wget
# RUN wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
# RUN echo 'deb http://packages.elasticsearch.org/logstashforwarder/debian stable main' | sudo tee /etc/apt/sources.list.d/logstashforwarder.list
# RUN apt-get update
# RUN apt-get install --no-install-recommends -y logstash-forwarder

# install the httpapi
ADD buddycloud-http-api.deb /tmp/buddycloud-http-api.deb
RUN dpkg -i /tmp/buddycloud-http-api.deb
ADD config.js /usr/share/buddycloud-http-api/config.js

# add logstash conf
# ADD logstash.conf /tmp/logstash.conf

# run the httpapi
ENTRYPOINT cd /usr/share/buddycloud-http-api; node -v; cat config.js; node server.js

EXPOSE 9123
