FROM ubuntu:18.04
WORKDIR /root
RUN apt-get update && apt-get install --no-install-recommends -y pbuilder debootstrap devscripts ubuntu-dev-tools qemu qemu-user-static binfmt-support wget && rm -rf /var/lib/apt/lists/*;
RUN wget https://ftp.debian.org/debian/pool/main/d/debian-archive-keyring/debian-archive-keyring_2021.1.1_all.deb
RUN dpkg -i debian-archive-keyring_2021.1.1_all.deb
RUN echo 'for arch in amd64 i386; do pbuilder-dist bullseye $arch create --mirror "http://deb.debian.org/debian/" --othermirror "deb http://security.debian.org/debian-security bullseye-security main|deb-src http://security.debian.org/ bullseye-security main|deb http://deb.debian.org/debian bullseye-updates main|deb-src http://deb.debian.org/debian bullseye-updates main"; done' > /root/pbuilder-bootstrap.sh
RUN apt-get install -y --no-install-recommends --reinstall qemu-user-static && rm -rf /var/lib/apt/lists/*;
RUN echo 'PBUILDERSATISFYDEPENDSCMD="/usr/lib/pbuilder/pbuilder-satisfydepends-apt" \n\
USENETWORK=yes \n\
 ' >> /etc/pbuilderrc
RUN chmod +x /root/pbuilder-bootstrap.sh
COPY ./entrypoint.sh /
CMD ["sh","/root/pbuilder-bootstrap.sh"]
