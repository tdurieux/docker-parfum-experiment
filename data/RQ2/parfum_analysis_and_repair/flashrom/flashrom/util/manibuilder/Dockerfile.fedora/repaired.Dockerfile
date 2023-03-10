FROM manibase

RUN \
	useradd -p locked -m mani && \
	dnf install -q -y git gcc ccache make \
		pciutils-devel libusb-devel libusbx-devel libftdi-devel \
		libjaylink-devel && \
	dnf clean -q -y all

USER mani
RUN \
	cd && \
	mkdir .ccache && chown mani:mani .ccache && \
	git clone https://review.coreboot.org/flashrom.git

ENV DEVSHELL /bin/bash
COPY mani-wrapper.sh /home/mani/
ENTRYPOINT ["/bin/sh", "/home/mani/mani-wrapper.sh"]