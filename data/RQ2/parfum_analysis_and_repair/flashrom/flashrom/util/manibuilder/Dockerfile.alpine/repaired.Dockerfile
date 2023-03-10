FROM manibase

RUN \
	adduser -D mani mani && \
	apk update && \
	apk add --no-cache build-base linux-headers git ccache \
		pciutils-dev libusb-compat-dev libusb-dev

USER mani
RUN \
	cd && \
	mkdir .ccache && chown mani:mani .ccache && \
	git clone https://review.coreboot.org/flashrom.git

ENV DEVSHELL /bin/sh
COPY mani-wrapper.sh /home/mani/
ENTRYPOINT ["/bin/sh", "/home/mani/mani-wrapper.sh"]
