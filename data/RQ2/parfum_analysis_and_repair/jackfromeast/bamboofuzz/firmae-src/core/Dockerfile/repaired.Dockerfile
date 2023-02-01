FROM ubuntu:18.04
MAINTAINER Mingeun Kim <pr0v3rbs@kaist.ac.kr>, Minkyo Seo <0xsaika@gmail.com>

RUN apt-get update && apt-get -y dist-upgrade
RUN apt-get install --no-install-recommends -y apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget bc psmisc ruby telnet && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y net-tools iputils-ping iptables iproute2 curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yy python3 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN python3 -m pip install --upgrade pip

RUN apt-get install --no-install-recommends -y libpq-dev && rm -rf /var/lib/apt/lists/*;
RUN python3 -m pip install psycopg2 psycopg2-binary

RUN apt-get install --no-install-recommends -y busybox-static bash-static fakeroot git kpartx netcat-openbsd nmap python3-psycopg2 snmp uml-utilities util-linux vlan && rm -rf /var/lib/apt/lists/*;

# for binwalk
# bypass tzdata interaction
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install --no-install-recommends -y binwalk mtd-utils gzip bzip2 tar arj lhasa p7zip p7zip-full cabextract fusecram cramfsswap squashfs-tools sleuthkit default-jdk cpio lzop lzma srecord zlib1g-dev liblzma-dev liblzo2-dev && rm -rf /var/lib/apt/lists/*;

RUN python3 -m pip install python-lzo cstruct git+https://github.com/sviehb/jefferson ubi_reader
RUN apt-get install --no-install-recommends -y python3-magic unrar && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;
RUN python3 -m pip install git+https://github.com/ReFirmLabs/binwalk

# for qemu
RUN apt-get install --no-install-recommends -y qemu-system-arm qemu-system-mips qemu-system-x86 qemu-utils && rm -rf /var/lib/apt/lists/*;

# for analyzer
RUN python3 -m pip install selenium bs4 requests future paramiko pysnmp==4.4.6 pycryptodome
# google chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | tee /etc/apt/sources.list.d/google-chrome.list
RUN apt-get update
RUN apt-get install --no-install-recommends -y google-chrome-stable && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ntfs-3g && rm -rf /var/lib/apt/lists/*;
RUN ln -s /bin/ntfs-3g /bin/mount.ntfs-3g

COPY ./sudo /usr/bin/sudo
RUN chmod 777 /usr/bin/sudo

RUN mkdir -p /work/FirmAE
RUN mkdir -p /work/firmwares
COPY sasquatch /usr/local/bin/
COPY cramfsck /usr/local/bin/
COPY yaffshiv /usr/local/bin/
COPY unstuff /usr/local/bin/

ENV USER=root
ENV FIRMAE_DOCKER=true
