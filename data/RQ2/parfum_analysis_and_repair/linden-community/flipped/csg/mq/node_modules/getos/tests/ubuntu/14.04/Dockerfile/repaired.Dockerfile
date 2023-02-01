FROM ubuntu:14.04

RUN apt-get update && \
    apt-get install --no-install-recommends -y --force-yes \
      curl \
      apt-transport-https \
      lsb-release \
      build-essential \
      python-all && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup | bash -
RUN apt-get update
RUN apt-get install --no-install-recommends nodejs -y --force-yes && rm -rf /var/lib/apt/lists/*;

ADD . /usr/src/
WORKDIR /usr/src/

CMD ["node","test.js"]
