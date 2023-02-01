FROM ecoron/python36-sklearn
MAINTAINER ecoron

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y --no-install-recommends install git wget curl sudo && rm -rf /var/lib/apt/lists/*;
RUN apt-get autoremove
RUN apt-get autoclean

RUN mkdir serpscrap
# COPY install_chrome.sh .install_chrome.sh
# RUN sh .install_chrome.sh

RUN pip install --no-cache-dir SerpScrap

# ENTRYPOINT python
