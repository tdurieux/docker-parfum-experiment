FROM ubuntu:18.04
ARG VERSION
ARG DEBVER

RUN apt update && apt install --no-install-recommends -y \
        software-properties-common && \
    add-apt-repository -y ppa:lramage/sds && rm -rf /var/lib/apt/lists/*;

RUN apt update && apt install --no-install-recommends -y \
        automake \
        build-essential \
        curl \
        debhelper \
        devscripts \
        git \
        indent \
        libcurl4-openssl-dev \
        libjansson-dev \
        libjwt-dev \
        libpam0g-dev \
        libsds-dev \
        libssl-dev \
        libtool \
        pkg-config \
        quilt \
        uuid-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/pam_aad
COPY . /usr/src/pam_aad
RUN tar cvzf "../pam-aad_${VERSION}.orig.tar.gz" --exclude='.git*' . && \
    debuild -us -uc -d -i'(.*)' && \
    dpkg -i "../libpam-aad_${VERSION}-${DEBVER}_amd64.deb"
