FROM python:3.6-slim-buster

# ensure unoconv can locate the uno library
ENV PYTHONPATH /usr/lib/python3/dist-packages

RUN usermod -d /home www-data \
    && chown www-data:www-data /home \
    # -slim images strip man dirs, but java won't install unless this dir exists.
    && mkdir -p /usr/share/man/man1 \
    && apt-get update \
    # mfr dependencies \
    && apt-get install --no-install-recommends -y \
        git \
        make \
        gcc \
        build-essential \
        gfortran \
        r-base \
        libblas-dev \
        libevent-dev \
        libfreetype6-dev \
        libjpeg-dev \
        libpng-dev \
        libtiff5-dev \
        libxml2-dev \
        libxslt1-dev \
        zlib1g-dev \
        gnupg2 \
        # convert .step to jsc3d-compatible format
        freecad \
        # pspp dependencies
        pspp \
        # unoconv dependencies
        libreoffice \
        # grab gosu for easy step-down from root
        gosu \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /code
WORKDIR /code

RUN pip install --no-cache-dir -U pip==18.1
RUN pip install --no-cache-dir setuptools==37.0.0
RUN pip install --no-cache-dir unoconv==0.8.2

COPY ./requirements.txt /code/

RUN pip install --no-cache-dir -r ./requirements.txt

# Copy the rest of the code over
COPY ./ /code/

ARG GIT_COMMIT=
ENV GIT_COMMIT ${GIT_COMMIT}

RUN python setup.py develop

EXPOSE 7778

CMD ["gosu", "www-data", "invoke", "server"]
