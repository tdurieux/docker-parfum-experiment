FROM golang:1.7
MAINTAINER Miki Tebeka <miki.tebeka@gmail.com>


ENV DISPLAY :99
RUN apt-get update && apt-get install --no-install-recommends -y xvfb iceweasel openjdk-7-jre-headless && rm -rf /var/lib/apt/lists/*;
VOLUME /code
