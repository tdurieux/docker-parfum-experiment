FROM python:3.7

WORKDIR /root
ENV http_proxy $proxy
ENV https_proxy $proxy
ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/

RUN mkdir -p $output

RUN if [ -n $dns ]; \
    then echo "nameserver $dns" >> /etc/resolv.conf;\
    fi; \
    apt-get install -y --no-install-recommends git ca-certificates && rm -rf /var/lib/apt/lists/*;

ADD certs/ /usr/local/share/ca-certificates/
ADD certs/ /etc/ssl/certs/
RUN update-ca-certificates

RUN if [ -n $dns ];\
    then echo "nameserver $dns" >> /etc/resolv.conf;\
    fi;\
    git clone https://github.com/fleetcaptain/Turbolist3r.git /root/turbo

WORKDIR /root/turbo

RUN if [ -n $dns ]; \
    then echo "nameserver $dns" >> /etc/resolv.conf;\
    fi; \
    pip3 install --no-cache-dir -r requirements.txt

ENTRYPOINT python3 turbolist3r.py --domain $target -o $output/sublist3r.txt
