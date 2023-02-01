FROM debian:buster AS buster

RUN echo "deb http://deb.debian.org/debian buster-backports main " >> /etc/apt/sources.list

RUN apt update
RUN apt install --no-install-recommends -y apt-utils apt-transport-https ca-certificates debian-archive-keyring && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y wget curl tree git gcc build-essential libelf-dev; rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y linux-kbuild*; rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y linux-headers*amd64 && rm -rf /var/lib/apt/lists/*;
RUN apt -t buster-backports --no-install-recommends install -y linux-headers*amd64 && rm -rf /var/lib/apt/lists/*;
RUN wget https://mirrors.bytedance.com/debian/pool/buster-main/l/linux-4.19.117.bsk.business.1-amd64/linux-headers-4.19.117.bsk.business.1-amd64_4.19.117.bsk.business.1_amd64.deb && dpkg -i linux-headers-4.19.117.bsk.business.1-amd64_4.19.117.bsk.business.1_amd64.deb
RUN wget https://mirrors.bytedance.com/debian/pool/buster-main/l/linux-5.4.56.bsk.business.1-amd64/linux-headers-5.4.56.bsk.business.1-amd64_5.4.56.bsk.business.1-58-g64b2babf3f47_amd64.deb && dpkg -i linux-headers-5.4.56.bsk.business.1-amd64_5.4.56.bsk.business.1-58-g64b2babf3f47_amd64.deb
RUN wget https://mirrors.bytedance.com/debian/pool/buster-main/l/linux-4.19.36.bsk.business.1-amd64/linux-headers-4.19.36.bsk.business.1-amd64_4.19.36.bsk.business.1-214-gfa3405186ab1_amd64.deb && dpkg -i linux-headers-4.19.36.bsk.business.1-amd64_4.19.36.bsk.business.1-214-gfa3405186ab1_amd64.deb

RUN apt clean all

ADD . /elkeid
WORKDIR /elkeid/driver
RUN bash ./batch_compile.sh