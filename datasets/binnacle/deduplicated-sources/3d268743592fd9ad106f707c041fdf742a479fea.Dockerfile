FROM python:3.6.5-jessie as python-binary
# /usr/local in this image only has its own built Python.
RUN cd /; \
    tar czpf python.tar.gz \
        /usr/local/bin \
        /usr/local/lib/libpython* \
        /usr/local/lib/python3.6* \
        /usr/local/include


# ------------------------
FROM lablup/kernel-base:ubuntu16.04-mkl2018.3
ENV LANG=C.UTF-8
ENV PYTHONUNBUFFERED 1

RUN apt-get update && apt-get install -y \
        ca-certificates \
        wget \
        libexpat1 libgdbm3 bzip2 libffi6 libsqlite3-0 liblzma5 zlib1g \
        libssl1.0.0 libmpdec2 \
        libncursesw5 libtinfo5 libreadline6 \
        libproj-dev libgeos-dev \
        mime-support \
        libzmq3-dev libuv1

# Copy the whole Python from the docker library image
COPY --from=python-binary /python.tar.gz /
RUN cd /; tar xzpf python.tar.gz; rm python.tar.gz; ldconfig

# Test if Python is working
RUN python -c 'import sys; print(sys.version_info); import ssl'

# As we mostly have "manylinux" glibc-compatible binary packaes,
# we don't have to rebuild these!
RUN pip install --no-cache-dir pyzmq simplejson msgpack-python uvloop && \
    pip install --no-cache-dir aiozmq dataclasses tabulate namedlist six "python-dateutil>=2"

# vim: ft=dockerfile
