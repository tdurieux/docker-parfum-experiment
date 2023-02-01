FROM debian:jessie

MAINTAINER Akhil Mohan "akhilerm@gmail.com"

RUN apt-get update
RUN apt-get install --no-install-recommends -y python && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y default-jdk && rm -rf /var/lib/apt/lists/*;
RUN mkdir /tmp/user /tmp/answer

ADD storage/app/public/drivers /tmp/driver

#should include code to remove unwanted modules from python in next build
#should include driver files in the image itself
