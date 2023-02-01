FROM arm64v8/python:3.7-slim-buster

WORKDIR /app

RUN apt-get update \
    && apt-get install --no-install-recommends -y gcc cmake git zlib1g-dev \
    && git clone https://github.com/FFmpeg/FFmpeg \
    && cd FFmpeg \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-encoders --disable-decoders --enable-decoder=mjpeg --enable-decoder=h264 --enable-encoder=png \
    && make clean \
    && make -j $(nproc) \
    && make install \
    && cd .. \
    && rm -rf FFmpeg \
    && apt-get purge --auto-remove -y gcc cmake git \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "python3", "-u", "./main.py" ]

