FROM python:3.5


RUN echo "deb http://httpredir.debian.org/debian jessie-backports main" > \
        /etc/apt/sources.list.d/backports.list && \
        apt-get clean && \
        apt-get update && \
        apt-get install --no-install-recommends -y \
        build-essential \
        cmake \
        git \
        wget \
        unzip \
        yasm \
        pkg-config \
        libswscale-dev \
        libtbb2 \
        libtbb-dev \
        libjpeg-dev \
        libpng-dev \
        libtiff-dev \
        libjasper-dev \
        libavformat-dev \
        libpq-dev \
        libfreetype6-dev \
        ffmpeg && rm -rf /var/lib/apt/lists/*;


RUN apt-get clean && \
    apt-get install --no-install-recommends -y \
    python3-matplotlib \
    python3-numpy \
    python3-scipy \
    python3-pip \
    && \
    rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --upgrade --no-cache-dir \
        sk-video \
        flake8 \
        pep8 \
        tqdm \
        matplotlib \
        scikit-image \
        sklearn

WORKDIR /src/
CMD bash main.sh
