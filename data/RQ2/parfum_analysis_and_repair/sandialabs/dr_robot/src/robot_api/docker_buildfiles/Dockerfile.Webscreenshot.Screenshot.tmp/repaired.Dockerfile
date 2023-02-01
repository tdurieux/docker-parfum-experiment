FROM ubuntu:latest

ENV http_proxy $proxy
ENV https_proxy $proxy

RUN mkdir -p $output/webscreenshot

RUN if [ -n $dns ]; \
    then echo "nameserver $dns" >> /etc/resolv.conf;\
    fi; \
    apt-get update \
    && apt-get install --no-install-recommends -y wget git python python-pip chromium-browser xvfb firefox phantomjs ca-certificates && rm -rf /var/lib/apt/lists/*;

ADD certs/ /usr/local/share/ca-certificates/
RUN update-ca-certificates


RUN if [ -n $dns ]; \
    then echo "nameserver $dns" >> /etc/resolv.conf;\
    fi;\
    git clone https://github.com/maaaaz/webscreenshot.git webscreenshot

WORKDIR webscreenshot

RUN if [ -n $dns ]; \
    then echo "nameserver $dns" >> /etc/resolv.conf;\
    fi; \
    pip install --no-cache-dir -r requirements.txt

RUN if [ -n $dns ]; \
    then echo "nameserver $dns" >> /etc/resolv.conf;\
    fi; \
    pip install --no-cache-dir -r requirements.txt


ENTRYPOINT python webscreenshot.py -i $infile -o $output/webscreenshot -r $tool --no-xserver
