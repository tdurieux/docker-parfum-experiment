FROM debian:stable

ARG PKG_PATH=http://cdn.netbsd.org/pub/pkgsrc/packages/NetBSD/amd64/7.1/All
ARG INST_IMG=http://ftp.de.netbsd.org/pub/NetBSD/NetBSD-7.1/amd64/
ARG DISK_SIZE=1G
ARG INSTALL_MEM=128M
ARG EXTRA_PKG=""

RUN \
	useradd -p locked -m mani && \
	apt-get -qq update && \
	apt-get -qq upgrade && \
	apt-get -qq dist-upgrade && \
	apt-get -qqy --no-install-recommends install git python python-pexpect \
								genisoimage qemu-system && \
	apt-get clean && \
	git clone https://github.com/gson1703/anita.git && \
	cd anita && python setup.py install && rm -rf /var/lib/apt/lists/*;

USER mani
RUN cd && mkdir .ccache && chown mani:mani .ccache && \
	  anita --sets kern-GENERIC,modules,base,etc,comp \
		--disk-size ${DISK_SIZE} --memory-size=${INSTALL_MEM} \
		install ${INST_IMG} && \
	  rm -rf work-*/download

ARG RUNTIME_MEM=128M
RUN cd && anita --persist --memory-size=${RUNTIME_MEM} --run \
"echo 'dhcpcd'                                   >init && \
 echo 'export PKG_PATH=${PKG_PATH}'             >>init && \
 . ./init && \
 pkg_add gmake git-base ccache pciutils libusb1 libusb-compat libftdi \
         ${EXTRA_PKG} && \
 git config --global --add http.sslVerify false && \
 git clone https://review.coreboot.org/flashrom.git" \
		boot ${INST_IMG}

RUN cd && dd if=/dev/zero bs=1M count=64 of=cache.img && \
	  anita --vmm-args '-hdb cache.img' --persist \
		--memory-size=${RUNTIME_MEM} --run \
"if [ \$(uname -m) = i386 -o \$(uname -m) = amd64 ]; then \
     bdev=wd1d; \
 else \
     bdev=wd1c; \
 fi; \
 newfs -I \${bdev} && \
 mkdir .ccache && \
 mount /dev/\${bdev} .ccache && \
 ccache -M 60M && \
 umount .ccache && \
 echo 'manitest() {'                            >>init && \
 echo '    fsck -y -t ffs /dev/'\${bdev}        >>init && \
 echo '    mount /dev/'\${bdev}' ~/.ccache'     >>init && \
 echo '    (cd ~/flashrom && eval \" \$*\")'    >>init && \
 echo '    ret=\$?'                             >>init && \
 echo '    umount ~/.ccache'                    >>init && \
 echo '    return \$ret'                        >>init && \
 echo '}'                                       >>init" \
		boot ${INST_IMG} && \
	  gzip cache.img

COPY anita-wrapper.sh /home/mani/mani-wrapper.sh
ENV INST_IMG ${INST_IMG}
ENV MEM_SIZE ${RUNTIME_MEM}
ENTRYPOINT ["/bin/sh", "/home/mani/mani-wrapper.sh"]
