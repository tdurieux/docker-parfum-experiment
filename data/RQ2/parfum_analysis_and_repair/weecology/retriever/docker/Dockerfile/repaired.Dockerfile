# Download base image ubuntu .04
FROM osgeo/gdal

MAINTAINER Weecology "https://github.com/weecology/retriever"

# Installing Gdal and configuring it
RUN export CPLUS_INCLUDE_PATH=/usr/include/gdal &&\
    export C_INCLUDE_PATH=/usr/include/gdal &&\
    apt-get update && apt-get install -y --no-install-recommends apt-utils && \
    # Manually install tzdata to allow for non-interactive install
    apt-get install --no-install-recommends -y --force-yes tzdata && \
    apt-get install --no-install-recommends -y --force-yes build-essential wget git locales locales-all > /dev/null && \
    apt-get install --no-install-recommends -y --force-yes postgresql-client mariadb-client > /dev/null && \
    apt-get install --no-install-recommends -y --force-yes libpq-dev && \
    apt-get install --no-install-recommends -y --force-yes libgdal-dev && \
    apt install --no-install-recommends -y --force-yes gdal-bin && \
    # Installing postgis
    apt-get install --no-install-recommends -y --force-yes postgis && rm -rf /var/lib/apt/lists/*;

# Set encoding
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Remove python2 and install python3
RUN apt-get remove -y python && apt-get install --no-install-recommends -y python3 python3-pip curl && \
    rm -f /usr/bin/python && ln -s /usr/bin/python3 /usr/bin/python && \
    rm -f /usr/bin/pip && ln -s /usr/bin/pip3 /usr/bin/pip && rm -rf /var/lib/apt/lists/*;

RUN echo "export PATH="/usr/bin/python:$PATH"" >> ~/.profile &&\
    echo "export PYTHONPATH="/usr/bin/python:$PYTHONPATH"" >> ~/.profile &&\
    echo "export PGPASSFILE="~/.pgpass"" >> ~/.profile

# Add permissions to config files
RUN chmod 0644 ~/.profile

RUN pip install --no-cache-dir pymysql && \
    pip install --no-cache-dir psycopg2-binary -U && \
    pip install --no-cache-dir codecov -U && \
    pip install --no-cache-dir pytest-cov -U && \
    pip install --no-cache-dir pytest-xdist -U && \
    pip install --no-cache-dir pytest && \
    pip install --no-cache-dir yapf && \
    pip install --no-cache-dir pylint && \
    pip install --no-cache-dir flake8 -U && \
    pip install --no-cache-dir h5py && \
    pip install --no-cache-dir Pillow && \
    pip install --no-cache-dir kaggle && \
    pip install --no-cache-dir inquirer && \
    pip install --no-cache-dir numpy
RUN pip install --no-cache-dir GDAL
COPY . ./retriever/
WORKDIR ./retriever/
RUN chmod 0755 cli_tools/entrypoint.sh
ENTRYPOINT ["cli_tools/entrypoint.sh"]

RUN pip install --no-cache-dir git+https://git@github.com/weecology/retriever.git
# Add permissions to config files
# Do not run these cmds before Entrypoint.
RUN export PGPASSFILE="~/.pgpass" &&\
    chmod 600 cli_tools/.pgpass &&\
    chmod 600 cli_tools/.my.cnf

CMD ["bash", "-c", "python --version"]
