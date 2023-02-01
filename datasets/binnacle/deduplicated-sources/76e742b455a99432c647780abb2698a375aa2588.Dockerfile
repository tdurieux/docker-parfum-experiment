FROM python:2.7-alpine3.7 as python-source
# /usr/local in this image only has its own built Python.
RUN cd /; \
    tar czpf python.tar.gz \
        /usr/local/bin \
        /usr/local/lib/libpython* \
        /usr/local/lib/python2.7* \
        /usr/local/include


# ------------------------
FROM lablup/kernel-base-python-wheels:2.7-alpine as wheel-builds


# ------------------------
FROM lablup/kernel-base:alpine

# Consult this on https://pkgs.alpinelinux.org/package/edge/main/x86_64/python3
# NOTE: it should depend only on libressl but for somehow reason it actually requires openssl.
RUN apk add --no-cache ca-certificates \
        wget \
        expat gdbm libbz2 libffi openssl ncurses-libs readline sqlite-libs xz-libs zlib

# Copy the whole Python from the docker library image
COPY --from=python-source /python.tar.gz /
COPY --from=wheel-builds /root/pyzmq*.whl /tmp/
COPY --from=wheel-builds /root/simplejson*.whl /tmp/
RUN cd /; tar xzpf python.tar.gz; rm python.tar.gz

# Test if Python is working
RUN python -c 'import sys; print(sys.version_info); import ssl'

# Lablup extension: install Sorna's common Python packages
RUN apk add --no-cache --virtual .sorna-deps zeromq libuv \
    && pip install --no-cache-dir /tmp/*.whl \
    && pip install --no-cache-dir namedlist six "python-dateutil<2" \
    && rm /tmp/*.whl

CMD ["/home/sorna/jail", "-policy", "/home/sorna/policy.yml", "/usr/local/bin/python", "/home/sorna/run.py"]

# vim: ft=dockerfile
