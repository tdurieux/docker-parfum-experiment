# Hack to upload version to Pypi

FROM registry.opensource.zalan.do/library/python-3.9 AS builder
ARG VERSION
RUN apt-get update && \
    apt-get install --no-install-recommends -q -y python3-pip && \
    pip3 install --no-cache-dir -U tox setuptools && rm -rf /var/lib/apt/lists/*;
COPY . /build
WORKDIR /build
RUN sed -i "s/__version__ = .*/__version__ = '${VERSION}'/" */__init__.py
RUN python3 setup.py sdist bdist_wheel

FROM pierone.stups.zalan.do/teapot/python-cdp-release:latest
COPY --from=builder /build/dist /pydist
