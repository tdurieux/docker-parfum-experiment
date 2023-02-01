FROM ubuntu

MAINTAINER holgerbrandl@gmail.com

RUN apt-get update
RUN apt-get install --no-install-recommends -y zip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
