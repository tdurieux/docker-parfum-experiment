FROM ubuntu:20.04

RUN apt-get --yes update
RUN apt-get --yes --no-install-recommends install \
    libffi-dev \
    librsvg2-bin \
    libspatialindex6 \
    libxml2-dev \
    optipng \
    potrace \
    python3-lxml \
    python3-pil \
    python3-xcffib && rm -rf /var/lib/apt/lists/*;

RUN apt-get --yes --no-install-recommends install \
    python3-pip && rm -rf /var/lib/apt/lists/*;

WORKDIR /build

COPY MANIFEST.in ./
COPY README.rst ./
COPY setup.py ./
COPY requirements.txt ./

RUN pip3 install --no-cache-dir --user -r requirements.txt

COPY src/ ./src/

RUN pip3 install --no-cache-dir --user -e .

ENV PATH=$PATH:/root/.local/bin

CMD ["/root/.local/bin/piecemaker"]
