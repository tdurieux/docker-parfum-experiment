FROM python:3.8.1

WORKDIR /usr/src/bloxlink

ADD . /usr/src/bloxlink

RUN echo Attempting to Update && apt-get update || true && wget -O - https://github.com/jemalloc/jemalloc/releases/download/5.2.1/jemalloc-5.2.1.tar.bz2 | tar -xj && \
    cd jemalloc-5.2.1 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make && \
    make install

RUN pip3 install --no-cache-dir --trusted-host pypi.python.org -r requirements.txt
RUN apt install -y --no-install-recommends dumb-init && rm -rf /var/lib/apt/lists/*;

ENV LD_PRELOAD="/usr/local/lib/libjemalloc.so.2"

ENTRYPOINT ["dumb-init", "-v", "--", "python3", "src/bot.py"]