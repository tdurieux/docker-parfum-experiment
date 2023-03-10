FROM fedora:33

RUN dnf -y update
RUN dnf -y install \
	diffutils \
	gcc \
	glib2-devel \
	gnutls-utils \
	git-core \
	meson \
	mingw64-gcc \
	mingw64-glib2 \
	mingw64-gnutls \
	mingw64-json-glib \
	mingw64-pkg-config \
	redhat-rpm-config \
	shared-mime-info \
	wine
RUN echo fubar > /etc/machine-id
WORKDIR /build