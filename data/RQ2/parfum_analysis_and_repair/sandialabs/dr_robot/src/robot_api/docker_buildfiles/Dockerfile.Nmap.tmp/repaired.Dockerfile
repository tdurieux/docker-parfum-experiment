FROM ubuntu:18.04

ENV http_proxy $proxy
ENV https_proxy $proxy
ENV TARGET $target
ENV OUTPUT /tmp/output/eyewitness
ENV INFILE  $infile
ARG user=eyewitness

RUN if [ -n $dns ]; \
    then echo "nameserver $dns" >> /etc/resolv.conf; fi; \
    apt update; \
    apt install --no-install-recommends -y nmap git wget ca-certificates && rm -rf /var/lib/apt/lists/*;

ADD certs/ /usr/local/share/ca-certificates/
RUN update-ca-certificates

RUN if [ -n $dns ]; \
    then echo "nameserver $dns" >> /etc/resolv.conf; fi;\
    git clone https://github.com/SpiderLabs/Nmap-Tools.git \
    && cp Nmap-Tools/NSE/http-screenshot.nse /usr/share/nmap/scripts/http-screenshot.nse \
    && nmap --script-updatedb \
    && wget -O wkhtml.deb https://downloads.wkhtmltopdf.org/0.12/0.12.5/wkhtmltox_0.12.5-1.bionic_amd64.deb \
    && dpkg -i  wkhtml.deb
