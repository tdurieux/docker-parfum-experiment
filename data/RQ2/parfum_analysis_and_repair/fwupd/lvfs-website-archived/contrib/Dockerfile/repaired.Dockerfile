FROM centos:8

RUN dnf -y update
RUN dnf -y install dnf-plugins-core
RUN dnf config-manager --set-enabled PowerTools
RUN dnf -y install epel-release
RUN dnf -y install \
	bsdtar \
	geolite2-country \
	libgcab1 \
	cairo-gobject-devel \
	gobject-introspection-devel \
	gnutls-utils \
	gcc \
	python3-devel \
	python3-pip \
	python3-psutil \
	libcurl-devel \
	redis \
	words
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir pip -U
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt --use-feature=2020-resolver
RUN pip3 install --no-cache-dir mypy
RUN mkdir /build
WORKDIR /build
COPY . .
CMD ["./contrib/centos.sh"]
