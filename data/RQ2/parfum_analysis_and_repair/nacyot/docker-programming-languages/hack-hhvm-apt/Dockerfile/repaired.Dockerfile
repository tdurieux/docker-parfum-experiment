FROM nacyot/ubuntu
MAINTAINER Daekwon Kim <propellerheaven@gmail.com>

RUN wget -O - https://dl.hhvm.com/conf/hhvm.gpg.key | apt-key add -
RUN echo deb http://dl.hhvm.com/ubuntu trusty main | tee /etc/apt/sources.list.d/hhvm.list
RUN apt-get update && apt-get install --no-install-recommends -y hhvm && rm -rf /var/lib/apt/lists/*;

# Set default WORKDIR
WORKDIR /source
