FROM debian:jessie
MAINTAINER ld86

RUN apt-get update && apt-get install --no-install-recommends -y python2.7 python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir Flask

ADD main.py /root/

CMD ["/usr/bin/python2.7", "/root/main.py"]
