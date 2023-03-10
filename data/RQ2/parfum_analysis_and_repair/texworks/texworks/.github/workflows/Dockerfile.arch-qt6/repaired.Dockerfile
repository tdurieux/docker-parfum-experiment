FROM archlinux

# Workaround an issue of old docker running new glibc (faccessat2 being blocked)
# Modeled after https://github.com/lxqt/lxqt-panel/pull/1562/
ARG GLIBC=glibc-linux4-2.33-4-x86_64.pkg.tar.zst
RUN curl -f -LO https://repo.archlinuxcn.org/x86_64/$GLIBC && bsdtar -C / -xf $GLIBC

RUN pacman --noconfirm -Syu \
	cmake \
	gcc \
	git \
	make \
	hunspell \
	lua \
	poppler-qt6 \
	qt6-5compat \
	qt6-base \
	qt6-declarative \
	qt6-tools \
	gsfonts \
	poppler-data \
	xorg-server-xvfb \
&& pacman --noconfirm -Scc

COPY . /home/tw

RUN mkdir /home/tw/build && cd /home/tw/build && \
cmake -DQT_DEFAULT_MAJOR_VERSION=6 .. && \
make -j3 && \
xvfb-run ctest -V
