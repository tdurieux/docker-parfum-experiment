FROM debian:unstable

RUN apt-get update -qq && apt-get install -yq --no-install-recommends \
	gcovr \
	gobject-introspection \
	gtk-doc-tools \
	libgirepository1.0-dev \
	libglib2.0-bin \
	libglib2.0-dev \
	libstemmer-dev \
	ninja-build \
	python3-pip \
	python3-setuptools \
	python3-wheel \
	shared-mime-info \
	liblzma-dev \
	uuid-dev \
	pkg-config && rm -rf /var/lib/apt/lists/*;

# Meson is too old in unstable, and that won't change until Buster is released
RUN pip3 install --no-cache-dir meson

WORKDIR /build
