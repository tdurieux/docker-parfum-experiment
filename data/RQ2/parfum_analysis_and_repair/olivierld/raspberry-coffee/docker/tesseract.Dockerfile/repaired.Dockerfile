FROM ubuntu:18.04
# See
# https://github.com/tesseract-shadow/tesseract-ocr-re
#
# Uncomment the ENV lines if a proxy is needed.
#
# ENV http_proxy http://www-proxy.us.oracle.com:80
# ENV https_proxy http://www-proxy.us.oracle.com:80
#
RUN echo "alias ll='ls -lisah'" >> $HOME/.bashrc
RUN apt-get update
RUN apt-get install --no-install-recommends -y sysvbanner && rm -rf /var/lib/apt/lists/*;
RUN echo "banner Tesseract" >> $HOME/.bashrc
#
RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common && add-apt-repository -y ppa:alex-p/tesseract-ocr && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y tesseract-ocr-all && rm -rf /var/lib/apt/lists/*;

RUN mkdir /home/work
WORKDIR /home/work
