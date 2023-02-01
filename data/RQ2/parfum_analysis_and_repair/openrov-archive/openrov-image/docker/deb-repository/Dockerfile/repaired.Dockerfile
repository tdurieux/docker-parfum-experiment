FROM debian:wheezy
MAINTAINER OpenROV Inc - Dominik Fretz, dominik@openrov.com
ENV HOME /root
RUN apt-get update && apt-get install --no-install-recommends -y ruby1.9.3 rubygems gnupg gnupg-agent dpkg-sig && rm -rf /var/lib/apt/lists/*;
RUN gem install deb-s3
