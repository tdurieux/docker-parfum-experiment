FROM ubuntu:20.04

RUN apt update && apt install --no-install-recommends -y wget python3 python3-pip git libzstd-dev && rm -rf /var/lib/apt/lists/*;

RUN wget https://github.com/nanoporetech/vbz_compression/releases/download/v1.0.1/ont-vbz-hdf-plugin_1.0.1-1.focal_amd64.deb && apt install --no-install-recommends -y ./ont-vbz-hdf-plugin_1.0.1-1.focal_amd64.deb && rm ont-vbz-hdf-plugin_1.0.1-1.focal_amd64.deb && rm -rf /var/lib/apt/lists/*;

COPY ./requirements-benchmarks.txt /
RUN pip install --no-cache-dir -r /requirements-benchmarks.txt

COPY ./install_slow5.sh /
RUN /install_slow5.sh
ENV PATH="/slow5tools-v0.4.0/:$PATH"

RUN pip install --no-cache-dir numpy

COPY ./pod5_format*.whl /
RUN pip install --no-cache-dir *.whl && rm *.whl
