FROM ubuntu:16.04
MAINTAINER Nicolas Hernandez < nicolas.hernandez [ at ] gmail.com >

RUN echo deb http://downloads.skewed.de/apt/xenial xenial universe > /etc/apt/sources.list.d/my_xenial.list
RUN echo deb-src http://downloads.skewed.de/apt/xenial xenial universe >> /etc/apt/sources.list.d/my_xenial.list

RUN apt-get update \
&& apt-get install --no-install-recommends -y python3 \
&& apt-get install --no-install-recommends -y python3-pip \
# demo pyrata_re.py
&& apt-get install --no-install-recommends -y --allow-unauthenticated python3-graph-tool \
&& apt-get install --no-install-recommends -y python3-nltk \
&& apt-get install --no-install-recommends -y evince \
# brown, punkt...
&& python3 -m nltk.downloader all \
&& apt-get install --no-install-recommends -y wget \
&& rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir pyrata
RUN wget  -P /root https://raw.githubusercontent.com/nicolashernandez/PyRATA/master/pyrata_re.py