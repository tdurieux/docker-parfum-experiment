FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install --no-install-recommends libsdl1.2-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends zlib1g-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libglib2.0-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libbfd-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends build-essential -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends binutils -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends qemu -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libboost-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libtool -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends autoconf -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends sudo -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends xorg-dev -y && rm -rf /var/lib/apt/lists/*;



WORKDIR /decafroot
RUN git clone https://github.com/sycurelab/DECAF.git

RUN pwd & ls
#ADD . /decafroot

#configure sleuthkit

WORKDIR /decafroot/DECAF/decaf/shared/sleuthkit
RUN rm ./config/ltmain.sh
RUN ln -s /usr/share/libtool/build-aux/ltmain.sh ./config/ltmain.sh
RUN autoconf
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make
WORKDIR /decafroot/DECAF/decaf
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-tcg-taint --target-list=i386-softmmu

RUN make

RUN export uid=1000 gid=1000
RUN mkdir -p /home/db/
RUN echo "db:x:${uid}:${gid}:db,,,:/home/db:/bin/ bash" >> /etc/passwd
RUN echo "db:x:${uid}:" >> /etc/group
RUN echo "db ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/db
RUN chmod 0440 /etc/sudoers.d/db
RUN chown ${uid}:${gid} -R /home/db

USER db
ENV HOME /home/db


RUN apt-get update
#setup samba to share file between guest os and host for qemu
RUN apt-get install --no-install-recommends samba -y && rm -rf /var/lib/apt/lists/*;
WORKDIR /etc/samba/
RUN echo "[QEMU]" >> /etc/samba/smb.conf
RUN echo "	path=/app/" >>/etc/samba/smb.conf
RUN echo "	browseable = yes" >> /etc/samba/smb.conf
RUN echo "	guest ok = yes" >> /etc/samba/smb.conf
RUN echo "	writable = yes" >> /etc/samba/smb.conf
RUN echo "	create mask = 777" >> /etc/samba/smb.conf
RUN cat /etc/samba/smb.conf
#RUN /etc/init.d/samba start

WORKDIR /decafroot/
RUN apt install -y --no-install-recommends wget && rm -rf /var/lib/apt/lists/*;
RUN wget https://github.com/google/protobuf/releases/download/v3.5.0/protobuf-all-3.5.0.tar.gz
RUN tar -xvf protobuf-all-3.5.0.tar.gz && rm protobuf-all-3.5.0.tar.gz
WORKDIR /decafroot/protobuf-3.5.0
RUN ./autogen.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/
RUN make
RUN make install




WORKDIR /decafroot/DECAF/decaf/i386-softmmu/
#CMD ["/bin/bash"]
CMD export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/ &/etc/init.d/samba start & ./qemu-system-i386 -monitor stdio -m 256 -net user,smb=/app/ -netdev user,id=mynet -device rtl8139,netdev=mynet  /app/winxpsp3_ie6.1.img -s
#CMD /etc/init.d/samba status