FROM ubuntu:22.04

RUN apt-get -y update
RUN apt-get -y --no-install-recommends install apt-transport-https curl && rm -rf /var/lib/apt/lists/*;

RUN curl -f -s https://packagecloud.io/install/repositories/pagerduty/rundeck/script.deb.sh | os=any dist=any bash

RUN apt-get -y update
RUN apt-get install --no-install-recommends -y openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install rundeck-cli && rm -rf /var/lib/apt/lists/*;
