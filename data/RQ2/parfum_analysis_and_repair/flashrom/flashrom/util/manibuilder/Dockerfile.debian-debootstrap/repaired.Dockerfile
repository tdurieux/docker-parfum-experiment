FROM manibase

RUN \
	useradd -p locked -m mani && \
	apt-get -qq update && \
	apt-get -qq upgrade && \
	apt-get -qq dist-upgrade && \
	apt-get -qqy --no-install-recommends install gcc make git doxygen ccache pkg-config \
		libpci-dev libusb-dev libftdi-dev libusb-1.0-0-dev && \
	{ \
		apt-get -qqy --no-install-recommends install libjaylink-dev || true; \
} && \
	apt-get clean && rm -rf /var/lib/apt/lists/*;

USER mani
RUN \
	cd && \
	mkdir .ccache && chown mani:mani .ccache && \
	git clone https://review.coreboot.org/flashrom.git

ENV DEVSHELL /bin/bash
COPY mani-wrapper.sh /home/mani/
ENTRYPOINT ["/bin/sh", "/home/mani/mani-wrapper.sh"]
