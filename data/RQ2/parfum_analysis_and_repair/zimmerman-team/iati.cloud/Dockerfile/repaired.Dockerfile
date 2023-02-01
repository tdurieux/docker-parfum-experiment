FROM ubuntu:16.04

RUN apt-get -y update --fix-missing

RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:deadsnakes/ppa

RUN apt-get -y update --fix-missing

#TODO: all these need to be checked:
RUN apt-get -y --no-install-recommends install \

    build-essential \
    python3.6 \
    python3.6-dev \
    python3-pip \
    python3.6-venv \

    postgresql-client \
    git \
    libxml2-dev \
    libxslt1-dev \


    binutils \
    gdal-bin \
    libgeos-3.5.0 \
    libgeos-dev \
    libproj-dev \
    antiword \
    binutils \
    bzip2 \
    catdoc \
    docx2txt \
    gzip \
    html2text \
    libimage-exiftool-perl \
    odt2txt \
    perl \
    poppler-utils \
    unrar \
    unrtf \
    unzip \
    libpq-dev \
    python-psycopg2 \
    uwsgi \
    uwsgi-plugin-python \
    python3-pip \
    vim \
    locales && rm -rf /var/lib/apt/lists/*;

RUN python3.6 -m pip install pip --upgrade
RUN python3.6 -m pip install wheel

RUN mkdir /app

RUN pip3 install --no-cache-dir -U pip setuptools

ADD OIPA/requirements.txt /app/src/OIPA/requirements.txt

# Install Python dependencies
RUN pip3 install --no-cache-dir -r /app/src/OIPA/requirements.txt

ADD . /app/src

ENV PYTHONPATH="$PYTHONPATH:/usr/local/lib/python3.6/dist-packages"

# Set the locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN ["chmod", "+x", "/app/src/docker-entrypoint.sh"]