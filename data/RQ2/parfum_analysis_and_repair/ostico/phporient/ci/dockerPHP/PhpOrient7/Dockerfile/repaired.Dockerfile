FROM ubuntu:18.04

RUN apt-get update && apt-get -y --no-install-recommends install php-xml php-dev php-cli php-xdebug php-mbstring php-curl php-pdo php-xsl vim locate \
    iputils-ping curl wget net-tools psmisc dstat traceroute whois git unzip && rm -rf /var/lib/apt/lists/*; ENV DEBIAN_FRONTEND noninteractive




RUN apt full-upgrade

COPY run.sh /tmp/run.sh
RUN chmod +x /tmp/run.sh

WORKDIR "/home/PhpOrient"
CMD ["/tmp/run.sh"]
