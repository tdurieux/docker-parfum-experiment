FROM ubuntu:14.04

MAINTAINER Balram Ramanathan <balram.ramanathan@sirca.org.au>

RUN apt-get update && apt-get install --no-install-recommends -y gcc python2.7 python2.7-dev python-pip python-pandas && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir ipython[all] scipy
