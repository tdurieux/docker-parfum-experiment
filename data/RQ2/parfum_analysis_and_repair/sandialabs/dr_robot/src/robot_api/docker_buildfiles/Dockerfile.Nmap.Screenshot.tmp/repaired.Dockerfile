FROM ubuntu:18.04

ENV http_proxy $proxy
ENV https_proxy $proxy
ENV DNS $dns

RUN if [ -n $dns ]; \
    then echo "nameserver $dns" >> /etc/resolv.conf; fi; \
    apt update; \
    apt install --no-install-recommends -y nmap git wget libjpeg-turbo8 fontconfig libfreetype6 xfonts-base libxrender1 xfonts-75dpi chromium-browser firefox ca-certificates && rm -rf /var/lib/apt/lists/*;

ADD certs/ /usr/local/share/ca-certificates/
RUN update-ca-certificates

RUN if [ -n $dns ]; \
    then echo "nameserver $dns" >> /etc/resolv.conf; fi;\
    git clone https://github.com/CrimsonK1ng/nmap-screenshot.git \
    && cp nmap-screenshot/http-screenshot.nse /usr/share/nmap/scripts/http-screenshot.nse \
    && nmap --script-updatedb

RUN if [ -n $dns ]; \
    then echo "nameserver $dns" >> /etc/resolv.conf; fi;\
    wget -O wkhtml.deb https://downloads.wkhtmltopdf.org/0.12/0.12.5/wkhtmltox_0.12.5-1.bionic_amd64.deb \
    && dpkg -i  wkhtml.deb

WORKDIR $output

ENTRYPOINT mkdir -p $output/nmapscreen && cd $output/nmapscreen && nmap --script http-screenshot --script-args tool=$tool -iL $infile -p "80,8080,443,8888"
