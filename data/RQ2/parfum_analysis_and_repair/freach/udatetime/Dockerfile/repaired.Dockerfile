FROM ubuntu:16.04
MAINTAINER Simon Pirschel <simon@aboutsimon.com>
RUN apt-get update && apt-get install --no-install-recommends -y python python-dev python-pip python-setuptools build-essential git && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir git+https://github.com/freach/udatetime.git
