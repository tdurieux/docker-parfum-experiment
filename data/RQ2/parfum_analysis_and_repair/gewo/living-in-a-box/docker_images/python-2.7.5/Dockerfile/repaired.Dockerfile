# python (gewo/python)
FROM gewo/interactive
MAINTAINER Gebhard Wöstemeyer <g.woestemeyer@gmail.com>

RUN apt-get update && apt-get -y --no-install-recommends install python python-dev python-setuptools && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN easy_install pip
CMD ["/bin/bash"]
