FROM debian:10
LABEL maintainer=henri@dhcpy6d.de

# get build requirements
RUN apt -y update && apt -y --no-install-recommends install apt-utils \
                   build-essential \
                   dpkg-dev \
                   devscripts \
                   dh-python \
                   git \
                   gpg \
                   python3-all \
                   python3-distro \
                   python3-distutils \
                   python3-docutils \
                   python3-lib2to3 \
                   python3-setuptools \
                   sudo && rm -rf /var/lib/apt/lists/*;

# flexible entrypoint, mounted as volume
ENTRYPOINT ["/entrypoint.sh"]
