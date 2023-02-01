FROM archlinux/archlinux:base-devel

RUN mkdir -p /etc/pacman.d/hooks \
	&& ln -s /dev/null /etc/pacman.d/hooks/30-systemd-tmpfiles.hook

RUN pacman --noconfirm --ask=4 -Syy \
	&& pacman --needed --noconfirm --ask=4 -S \
		glibc \
		pacman \
	&& pacman-db-upgrade \
	&& pacman --noconfirm --ask=4 -Syu \
	&& pacman --needed --noconfirm --ask=4 -S \
		p11-kit \
		archlinux-keyring \
		ca-certificates \
		ca-certificates-mozilla \
		ca-certificates-utils \
	&& pacman --noconfirm --ask=4 -Syu \
	&& pacman --needed --noconfirm --ask=4 -S \
		arp-scan \
		python \
		parted \
		dosfstools \
		rsync \
	&& rm -rf /var/cache/pacman/pkg/*

RUN mkdir /tools
COPY install-binfmt /tools/
COPY docker-extract /tools/
COPY disk /tools/