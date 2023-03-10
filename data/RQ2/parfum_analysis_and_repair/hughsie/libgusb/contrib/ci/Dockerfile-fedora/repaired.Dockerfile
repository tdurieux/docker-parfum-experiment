FROM fedora:34

RUN dnf -y update
RUN dnf -y install \
	diffutils \
	glib2-devel \
	gobject-introspection-devel \
	gtk-doc \
	libusb1-devel \
	meson \
	redhat-rpm-config \
	rpm-devel \
	vala-devel \
	vala-tools
RUN mkdir /build
WORKDIR /build