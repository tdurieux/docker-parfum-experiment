FROM fedora:32

RUN dnf -y update
RUN dnf -y install \
	diffutils \
	gcovr \
	git-core \
	glib2-devel \
	gnutls-devel \
	gnutls-utils \
	gobject-introspection-devel \
	gpgme-devel \
	gtk-doc \
	json-glib-devel \
	meson \
	redhat-rpm-config \
	shared-mime-info \
	vala
RUN echo fubar > /etc/machine-id
WORKDIR /build