FROM ubuntu:20.04

RUN apt update \
    && apt-get install --no-install-recommends -y \
    g++ \
    libatlas-base-dev \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    swig && rm -rf /var/lib/apt/lists/*;

COPY amici.tar.gz /tmp

RUN pip3 install --no-cache-dir --upgrade pip build \
    && mkdir -p /tmp/amici/ \
    && cd /tmp/amici \
    && tar -xzf ../amici.tar.gz \
    && cd /tmp/amici/python/sdist \
    && python3 -m build --sdist \
    && pip3 install --no-cache-dir -v $(ls -t /tmp/amici/python/sdist/dist/amici-*.tar.gz | head -1)[petab] \
    && rm -rf /tmp && mkdir /tmp && rm ../amici.tar.gz
