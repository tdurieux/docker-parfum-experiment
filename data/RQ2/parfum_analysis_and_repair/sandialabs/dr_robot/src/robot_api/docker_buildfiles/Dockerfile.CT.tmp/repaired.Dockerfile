FROM python:3.6

ENV http_proxy $proxy
ENV https_proxy $proxy
ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/

RUN if [ -n $dns ]; \
    then echo "nameserver $dns" >> /etc/resolv.conf; fi; \
  apt-get update && apt-get install --no-install-recommends -y python-dev git ca-certificates && rm -rf /var/lib/apt/lists/*;

ADD certs/ /usr/local/share/ca-certificates/
ADD certs/ /etc/ssl/certs/
RUN update-ca-certificates

RUN if [ -n $dns ]; \
    then echo "nameserver $dns" >> /etc/resolv.conf; fi;\
 	git clone https://github.com/chris408/ct-exposer.git ctexposure


WORKDIR /ctexposure

RUN if [ -n $dns ]; \
    then echo "nameserver $dns" >> /etc/resolv.conf; fi; \
  pip3 install --no-cache-dir --trusted-host pypi.python.org --trusted-host --trusted-host -r requirements.txt

ENV INFILE  $infile

RUN mkdir -p $output

ENTRYPOINT python ct-exposer.py -d "$target" -m -u > $output/ctexposure.txt
