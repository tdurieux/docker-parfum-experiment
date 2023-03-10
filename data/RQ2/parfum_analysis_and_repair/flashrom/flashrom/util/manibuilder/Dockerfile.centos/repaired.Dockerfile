FROM manibase

RUN \
	useradd -p locked -m mani && \
	yum install -q -y git gcc pciutils-devel libusb-devel libusbx-devel && \
	yum clean -q -y all && rm -rf /var/cache/yum

USER mani
RUN \
	cd && \
	mkdir .ccache && chown mani:mani .ccache && \
	git clone https://review.coreboot.org/flashrom.git

ENV DEVSHELL /bin/bash
COPY mani-wrapper.sh /home/mani/
ENTRYPOINT ["/bin/sh", "/home/mani/mani-wrapper.sh"]
