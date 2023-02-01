FROM ubuntu:latest as builder
RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get --no-install-recommends install -y openssl && rm -rf /var/lib/apt/lists/*;
RUN mkdir /cert \
    && openssl req -x509 -subj "/C=US/ST=CA/O=Your Company/localityName=Your City/commonName=localhost/organizationalUnitName=Operations/emailAddress=someone@example.com" \
       -days 3650 -newkey rsa:2048 -nodes -keyout /cert/cinq-frontend.key -out /cert/cinq-frontend.crt \
    && openssl genrsa -out /cert/private.key 2048 \
    && mkdir /logfiles \
    && touch /logfiles/apiserver.log /logfiles/default.log /logfiles/scheduler.log

FROM python:3.5
COPY --from=builder /cert/* /usr/local/etc/cloud-inquisitor/ssl/
COPY --from=builder /logfiles/* /var/log/cloud-inquisitor/
COPY ./ /cloud-inquisitor
RUN apt-get update \
    && cd /cloud-inquisitor/backend \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y libxmlsec1-dev \
    && pip3 install --no-cache-dir virtualenv \
    && python3 -m virtualenv /env \
    && . /env/bin/activate \
    && python setup.py install && rm -rf /var/lib/apt/lists/*;

