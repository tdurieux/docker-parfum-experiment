# Firefox Addon SDK (gewo/firefox-addon-sdk)
FROM gewo/python
MAINTAINER Gebhard Wöstemeyer <g.woestemeyer@gmail.com>

RUN apt-get update && apt-get -y --no-install-recommends install curl git firefox && \
  apt-get clean && rm -rf /var/lib/apt/lists/*;

# install the SDK
RUN curl -f https://ftp.mozilla.org/pub/mozilla.org/labs/jetpack/jetpack-sdk-latest.tar.gz -L | tar -xzvf -
RUN ln -s /addon-sdk-1.17/bin/cfx ~/bin/cfx

CMD [/bin/bash]
