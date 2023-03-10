FROM ubuntu:16.04

WORKDIR /home
ENV http_proxy $proxy
ENV https_proxy $proxy
ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/

RUN mkdir -p $output

RUN if [ -n $dns ]; \
    then echo "nameserver $dns" >> /etc/resolv.conf;\
    fi; \
	apt-get update && \
    apt-get install --no-install-recommends -y libldns-dev git build-essential python wget && rm -rf /var/lib/apt/lists/*;

ADD certs/ /usr/local/share/ca-certificates/
ADD certs/ /etc/ssl/certs/
RUN update-ca-certificates

RUN if [ -n $dns ];\
    then echo "nameserver $dns" >> /etc/resolv.conf;\
    fi;\
    git clone https://github.com/blechschmidt/massdns.git /home/massdns

WORKDIR /home/massdns

RUN make
RUN echo $target > target.txt


ENTRYPOINT /bin/massdns -r /home/massdns/lists/resolvers.txt  -w $output/massdns.txt -t AAAA target.txt
