FROM fedora:31

RUN dnf -y update
RUN dnf -y install \
	diffutils \
	gcovr \
	xz-devel \
	git-core \
	glib2-devel \
	gobject-introspection-devel \
	gtk-doc \
	libabigail \
	libstemmer-devel \
	libuuid-devel \
	meson \
	shared-mime-info \
	redhat-rpm-config

WORKDIR /build