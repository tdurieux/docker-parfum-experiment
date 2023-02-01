FROM ubuntu:14.04

# If host is running squid-deb-proxy on port 8000, populate /etc/apt/apt.conf.d/30proxy
# By default, squid-deb-proxy 403s unknown sources, so apt shouldn't proxy ppa.launchpad.net
RUN route -n | awk '/^0.0.0.0/ {print $2}' > /tmp/host_ip.txt
RUN echo "HEAD /" | nc `cat /tmp/host_ip.txt` 8000 | grep squid-deb-proxy \
  && (echo "Acquire::http::Proxy \"http://$(cat /tmp/host_ip.txt):8000\";" > /etc/apt/apt.conf.d/30proxy) \
  && (echo "Acquire::http::Proxy::ppa.launchpad.net DIRECT;" >> /etc/apt/apt.conf.d/30proxy) \
  || echo "No squid-deb-proxy detected on docker host"

RUN apt-get update

RUN apt-get install --no-install-recommends -y imagemagick && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libmagickwand-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gifsicle && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install ruby1.9.1 ruby1.9.1-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential curl git vim && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y python-software-properties software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:mc3man/trusty-media
RUN apt-get update
RUN apt-get -y --no-install-recommends install ffmpeg && rm -rf /var/lib/apt/lists/*;

RUN gem install bundler --no-rdoc --no-ri
ADD Gemfile /tmp/Gemfile
ADD screengif.gemspec /tmp/screengif.gemspec
RUN cd /tmp; bundle install

WORKDIR /srv/screengif
