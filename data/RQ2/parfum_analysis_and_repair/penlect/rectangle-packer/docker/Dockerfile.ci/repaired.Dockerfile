# docker login gitlab.endian.se:4567
# docker build -t gitlab.endian.se:4567/daniel/rectangle-packer -f Dockerfile.ci .
# docker push gitlab.endian.se:4567/daniel/rectangle-packer

FROM debian:stable

RUN apt-get update && apt-get -y --no-install-recommends install \
        build-essential \
        devscripts \
        dpkg-dev \
        debhelper \
	dh-python \
        curl \
	python3-all \
        python3-dev \
	python3-setuptools \
	python3-numpy \
	python3-matplotlib \
	python3-sphinx \
        texlive-full \
        python3-pytest \
        python3-nose2 && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get -y --no-install-recommends install \
        python3-venv \
	python3-pip \
        python3-wheel \
	pylint3 \
	python3-sphinx-rtd-theme && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get -y --no-install-recommends install \
        openssh-client \
	rsync && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get -y --no-install-recommends install \
        cython3 && rm -rf /var/lib/apt/lists/*;
