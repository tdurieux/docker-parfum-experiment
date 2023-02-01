FROM base
MAINTAINER Cyril Mougel "cyril.mougel@gmail.com"

RUN apt-get update
RUN apt-get install --no-install-recommends -q -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -q -y ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -q -y make && rm -rf /var/lib/apt/lists/*;

## Ruby-install
RUN wget -O ruby-install-0.1.4.tar.gz https://github.com/postmodern/ruby-install/archive/v0.1.4.tar.gz
RUN tar -xzvf ruby-install-0.1.4.tar.gz && rm ruby-install-0.1.4.tar.gz

## install ruby 2.0.0
RUN ruby-install-0.1.4/bin/ruby-install ruby 2.0.0 -i /opt/rubies/ruby-2.0.0

ENV PATH /opt/rubies/ruby-2.0.0/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
