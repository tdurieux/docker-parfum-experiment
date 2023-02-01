FROM navitia/python

WORKDIR /usr/src/app
COPY navitia/source/jormungandr/requirements.txt /usr/src/app
COPY navitia/source/jormungandr/jormungandr /usr/src/app/jormungandr
COPY navitia/source/navitiacommon/navitiacommon /usr/src/app/navitiacommon

RUN apt-get update --fix-missing \
    &&  apt-get upgrade -y \
    && apt-get install --no-install-recommends -y \
        build-essential \
        python-dev \
        libgeos-c1 \
        libpq-dev \
        python-setuptools \
        curl \
        git \
    && pip install --no-cache-dir -r requirements.txt \
    && apt-get autoremove -y \
        build-essential \
        python-dev \
        python-setuptools \
        git && rm -rf /var/lib/apt/lists/*;

# ....
# I don't see a better way, geos try to find libc and fail, so ugly hack to give it
RUN ln -s /lib/ld-musl-x86_64.so.1 /usr/lib/libc.so

WORKDIR /usr/src/app/

HEALTHCHECK CMD curl -f http://localhost/v1 || exit 1
ENV PYTHONPATH=.
ENV PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=cpp
ENV PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION_VERSION=2
CMD ["uwsgi", "--master", "--lazy-apps", "--mount", "/=jormungandr:app", "--http", "0.0.0.0:80"]
