# Dockerfile for Lathermail
# For Docker-related questions please contact Sergey Arkhipov <sarkhipov@asdco.ru>
# Please contact Roman Haritonov <rharitonov@asdco.ru> for the rest of questions.
#
# To build image please do
# $ docker build -t lathermail .

FROM ubuntu:14.04
MAINTAINER Sergey Arkhipov <sarkhipov@asdco.ru>

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

ADD . .

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y --no-install-recommends install gcc && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install g++ && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python-pip && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -e .

EXPOSE 5000
EXPOSE 2525

ENTRYPOINT lathermail
CMD ["--api-host", "0.0.0.0", "--smtp-host", "0.0.0.0"]
