# Puppet Base Image (gewo/puppet)
# Includes: puppet, librarian-puppet
FROM gewo/base
MAINTAINER Gebhard Wöstemeyer <g.woestemeyer@gmail.com>
RUN apt-get -y update && apt-get -y --no-install-recommends install rubygems && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN gem install puppet librarian-puppet
RUN apt-get clean
