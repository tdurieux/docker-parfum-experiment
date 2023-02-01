FROM python:2.7

ENV http_proxy $proxy
ENV https_proxy $proxy
ENV DNS $dns
ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/


RUN if [ -n $dns ]; \
    then echo "nameserver $dns" >> /etc/resolv.conf;\
    fi; \
    apt-get install -y --no-install-recommends git ca-certificates && rm -rf /var/lib/apt/lists/*;

ADD certs/ /usr/local/share/ca-certificates/
ADD certs/ /etc/ssl/certs/
RUN update-ca-certificates

RUN if [ -n $dns ]; \
    then echo "nameserver $dns" >> /etc/resolv.conf;\
    fi;\
    cat /etc/resolv.conf ;\
    git clone https://github.com/infosec-au/altdns.git altdns

WORKDIR altdns

RUN if [ -n $dns ]; \
    then echo "nameserver $dns" >> /etc/resolv.conf;\
    fi;\
    python setup.py install

RUN cp $infile /tmp/infile.txt; \
    echo $target >> /tmp/infile.txt

RUN mkdir -p $output

WORKDIR $output

ENTRYPOINT altdns -i /tmp/infile.txt -w /altdns/words.txt -o altered.txt -s altnds.txt -r
