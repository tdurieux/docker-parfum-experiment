FROM python:2.7

WORKDIR /home

ENV http_proxy $proxy
ENV https_proxy $proxy
ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/

RUN mkdir -p $output

RUN if [ -n $dns ];\
    then echo "nameserver $dns" >> /etc/resolv.conf;\
    fi; \
	apt install --no-install-recommends -y git ca-certificates; rm -rf /var/lib/apt/lists/*; \
    pip install --no-cache-dir --trusted-host pypi.org dnspython;

ADD certs/ /usr/local/share/ca-certificates/
ADD certs/ /etc/ssl/certs/
RUN update-ca-certificates

RUN if [ -n $dns ];\
    then echo "nameserver $dns" >> /etc/resolv.conf;\
    fi;\
    git clone https://github.com/TheRook/subbrute.git /home/subbrute

RUN mkdir -p $output

WORKDIR /home/subbrute

ENTRYPOINT ./subbrute.py -o $output/subbrute.txt -r resolvers.txt -p -v $target
