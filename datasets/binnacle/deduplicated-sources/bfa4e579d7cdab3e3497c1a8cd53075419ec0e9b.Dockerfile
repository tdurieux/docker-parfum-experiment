FROM parrotsec/parrot-core:latest

MAINTAINER Vishnu Nair

RUN echo > /etc/apt/sources.list;\
    echo "deb http://mirrors.mit.edu/parrot/ parrot main contrib non-free" > /etc/apt/sources.list.d/parrot.list;\
    echo "deb-src http://mirrors.mit.edu/parrot/ parrot main contrib non-free" > /etc/apt/sources.list.d/parrot1.list;\
    wget -qO - https://archive.parrotsec.org/parrot/misc/parrotsec.gpg | apt-key add -;\
    apt-get update;\
    apt-get -y --no-install-recommends install -y traceroute dirb nikto dnsmap websploit libwww-perl uniscan wfuzz wapiti dnsrecon metagoofil theharvester nmap wafw00f wpscan sslscan sslyze whatweb joomscan python-pip git apt-transport-https dirmngr gnupg apt-utils wget ca-certificates curl build-essential python3-pkg-resources python3-setuptools python3-pip python-setuptools openssl;echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections;

RUN mkdir -p /src

WORKDIR /src

RUN pip install argparse netaddr mechanize droopescan;\
    git clone https://github.com/hahwul/a2sv.git;\
    git clone https://github.com/faizann24/XssPy.git;\
    git clone https://github.com/s0md3v/XSStrike.git && pip3 install -r /src/XSStrike/requirements.txt;\
    pip3 install setuptools

COPY pentest.sh /src/

CMD tail -f -n0 /etc/hosts
