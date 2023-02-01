FROM ubuntu:14.04

MAINTAINER Mingliang Liu <liuml07@gmail.com>

RUN apt-get update
RUN apt-get install --no-install-recommends -qq -y make && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -qq -y texlive-xetex && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -qq -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir beautifulsoup4 requests bibtexparser


ADD . google-scholar-citations
