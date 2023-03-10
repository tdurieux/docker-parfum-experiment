FROM python:2.7

WORKDIR /home
ENV http_proxy $proxy
ENV https_proxy $proxy

RUN if [ -n $dns ]; \
    then echo "nameserver $dns" >> /etc/resolv.conf;\
    fi; \
    apt-get update && \
    apt-get install --no-install-recommends -y git python-dnspython ca-certificates && \
			rm -rf /var/lib/apt/lists/*

ADD certs/ /usr/local/share/ca-certificates/
RUN update-ca-certificates

RUN if [ -n $dns ]; \
    then echo "nameserver $dns" >> /etc/resolv.conf;\
    fi;\
    git clone https://github.com/guelfoweb/knock.git /home/knock

WORKDIR /home/knock

RUN if [ -n $dns ]; \
    then echo "nameserver $dns" >> /etc/resolv.conf;\
    fi;\
    python setup.py install

RUN if [ -n "$VT_KEY" ]; \
    then sed -i ".orig" 's/""/"$VT_KEY"/g' knockpy/config.json;\
    fi

ENV TARGET $target
ENV OUTPUT $output
ENV VT_KEY $vt_key

RUN mkdir -p $output
WORKDIR $output

ENTRYPOINT knockpy -c $target
