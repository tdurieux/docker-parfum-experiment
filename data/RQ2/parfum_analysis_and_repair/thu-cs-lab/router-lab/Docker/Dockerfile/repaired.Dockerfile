FROM debian:bullseye
RUN sed -i 's/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list
RUN sed -i 's/security.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list
RUN apt update
RUN apt install --no-install-recommends -y python3-pip python3-py python3-lxml libxml2-dev libxslt-dev gpg wget && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple pyshark
RUN gpg --batch --keyserver hkp://keyserver.ubuntu.com --recv-keys E2BE4761926ABDB7A9525790D9006F13D7DB311A
RUN wget https://mirrors.tuna.tsinghua.edu.cn/debian/pool/main/libp/libpcap/libpcap_1.10.0.orig.tar.gz
RUN tar xvf libpcap_1.10.0.orig.tar.gz && rm libpcap_1.10.0.orig.tar.gz
WORKDIR libpcap-1.10.0
RUN apt install --no-install-recommends -y flex bison && rm -rf /var/lib/apt/lists/*;
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr --disable-dbus --disable-rdma --disable-usb --enable-shared
RUN make -j4 install

