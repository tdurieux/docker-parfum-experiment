FROM ubuntu:14.04
MAINTAINER zj1244
ENV LC_ALL C.UTF-8
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends curl python-pip python-dev flex bison libssl-dev libpcap-dev -y \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /opt/beholder_scanner

COPY . /opt/beholder_scanner

RUN set -x \
    && pip install --no-cache-dir --index-url https://pypi.tuna.tsinghua.edu.cn/simple -r /opt/beholder_scanner/requirements.txt \
    && cp /opt/beholder_scanner/scanner/config.py.sample /opt/beholder_scanner/scanner/config.py \
    && curl -fL -o /tmp/nmap.tar.bz2 \
         https://nmap.org/dist/nmap-7.80.tar.bz2 \
    && tar -xjf /tmp/nmap.tar.bz2 -C /tmp \
    && cd /tmp/nmap* \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make \
    && make install \
    && rm -rf /var/lib/apt/lists/* \
           /tmp/nmap* && rm /tmp/nmap.tar.bz2

WORKDIR /opt/beholder_scanner
CMD ["/bin/bash","-c","set -e && python main.py"]