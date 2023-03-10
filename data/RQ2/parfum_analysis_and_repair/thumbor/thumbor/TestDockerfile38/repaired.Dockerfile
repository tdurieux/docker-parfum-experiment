FROM python:3.8-slim
WORKDIR /app
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends --no-install-suggests \
        python3-dev \
        libcurl4-openssl-dev \
        libgnutls28-dev \
        libjpeg-progs \
        libimage-exiftool-perl \
        gifsicle \
        scons \
        python3-all-dev \
        libboost-python-dev \
        libexiv2-dev \
        ffmpeg \
        make \
        zlib1g-dev \
        gcc \
        libssl-dev \
        libjpeg-dev \
        libwebp-dev \
        redis && \
    apt-get install -y --reinstall --no-install-recommends --no-install-suggests build-essential && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN ln -s /usr/lib/x86_64-linux-gnu/libboost_python39.so /usr/lib/libboost_python38.so
RUN ln -s /usr/lib/x86_64-linux-gnu/libboost_python39.so /usr/lib/libboost_python3.so

RUN pip install --no-cache-dir --upgrade pip
