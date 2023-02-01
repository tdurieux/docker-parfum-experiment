FROM continuumio/miniconda3:4.5.11

# NOTE: Versions have been pinned everywhere. These are the latest versions at the moment, because
# I want to ensure predictable behavior, but I don't know of any problems with higher versions:
# It would be good to update these over time.

# "pip install clodius" complained about missing gcc,
# and "apt-get install gcc" failed and suggested apt-get update.
# (Was having some trouble with installs, so split it up for granular caching.)
RUN apt-get update && apt-get install -y \
        gcc \
        nginx \
        supervisor \
        unzip \
        uwsgi-plugin-python3 \
        zlib1g-dev \
        libcurl4-openssl-dev \
        g++ \
        vim \
        build-essential \
        libssl-dev \
        libpng-dev \
        htop \
        procps \
    && rm -rf /var/lib/apt/lists/*

# Keep big dependencies which are unlikely to change near the top of this file.
RUN conda install --yes cython==0.25.2 numpy=1.12.0
RUN conda install --yes --channel bioconda pysam htslib=1.3.2
RUN conda install -c conda-forge --yes uwsgi==2.0.17.1
# RUN pip install uwsgi==2.0.17


# Setup home directory
RUN groupadd -r higlass && useradd -r -g higlass higlass
WORKDIR /home/higlass
RUN chown higlass:higlass .
USER higlass


# Setup server
# Most dependencies should come from a cached layer, even before we checkout:
# The idea is that you want to be able to release small updates to the code,
# without having to refetch all dependencies.
USER root
RUN pip install pyBigWig
RUN pip install clodius==<CLODIUS_VERSION>
# This is *not* tagged: The idea here is *not* to bust the cache on every minor version.
RUN wget https://raw.githubusercontent.com/higlass/higlass-server/master/requirements.txt
RUN pip install -r requirements.txt

WORKDIR /home/higlass/projects
RUN chown higlass:higlass .
USER higlass
RUN git clone --depth 1 https://github.com/hms-dbmi/higlass-server.git --branch v<SERVER_VERSION>
RUN git clone https://github.com/vishnubob/wait-for-it.git
USER root

WORKDIR /home/higlass/projects/higlass-server
RUN python manage.py collectstatic --noinput -c

WORKDIR /home/higlass/projects
RUN pip install -r higlass-server/requirements.txt
USER higlass

# Setup application (includes client js)
ENV HIPILER_REPO hipiler
RUN wget -O hipiler.zip https://github.com/flekschas/$HIPILER_REPO/releases/download/v<HIPILER_VERSION>/build.zip
RUN unzip hipiler.zip -d hipiler

ENV WEB_APP_REPO higlass-app
RUN wget -O higlass-app.zip https://github.com/hms-dbmi/$WEB_APP_REPO/releases/download/v<WEB_APP_VERSION>/build.zip
RUN unzip higlass-app.zip -d higlass-app
# CHANGE THE NEXT LINE TO AFTER UPDATING HGLIB TO v1.3:
# RUN wget -O higlass-app/hglib.min.js https://unpkg.com/higlass@<LIBRARY_VERSION>/dist/hglib.min.js
RUN wget -O higlass-app/hglib.min.js https://unpkg.com/higlass@<LIBRARY_VERSION>/dist/hglib.js
RUN wget -O higlass-app/hglib.min.css https://unpkg.com/higlass@<LIBRARY_VERSION>/dist/hglib.css

RUN wget -O higlass-app/higlass-multivec.min.js https://unpkg.com/higlass-multivec@<MULTIVEC_VERSION>/dist/higlass-multivec.min.js
RUN wget -O higlass-app/higlass-time-interval-track.min.js https://unpkg.com/higlass-time-interval-track@<TIME_INTERVAL_TRACK_VERSION>/dist/higlass-time-interval-track.min.js
RUN wget -O higlass-app/higlass-linear-labels-track.min.js https://unpkg.com/higlass-linear-labels-track@<LINEAR_LABELS_TRACK_VERSION>/dist/higlass-linear-labels-track.min.js
RUN wget -O higlass-app/higlass-labelled-points-track.min.js https://unpkg.com/higlass-labelled-points-track@<LABELLED_POINTS_TRACK_VERSION>/dist/higlass-labelled-points-track.min.js

RUN wget -O higlass-app/higlass-bedlike-triangles-track.min.js https://unpkg.com/higlass-bedlike-triangles-track@<BEDLIKE_TRIANGLES_TRACK_VERSION>/dist/higlass-bedlike-triangles-track.min.js

RUN sed -i -e 's#<script src="/hglib.min.js"></script>#<script src="/higlass-multivec.min.js"></script><script src="/hglib.min.js"></script>#' higlass-app/index.html
RUN sed -i -e 's#<script src="/hglib.min.js"></script>#<script src="/higlass-time-interval-track.min.js"></script><script src="/hglib.min.js"></script>#' higlass-app/index.html
RUN sed -i -e 's#<script src="/hglib.min.js"></script>#<script src="/higlass-linear-labels-track.min.js"></script><script src="/hglib.min.js"></script>#' higlass-app/index.html
RUN sed -i -e 's#<script src="/hglib.min.js"></script>#<script src="/higlass-labelled-points-track.min.js"></script><script src="/hglib.min.js"></script>#' higlass-app/index.html

RUN ( echo "SERVER_VERSION: <SERVER_VERSION>"; \
      echo "WEB_APP_VERSION: <WEB_APP_VERSION>"; \
      echo "LIBRARY_VERSION: <LIBRARY_VERSION>"; \
      echo "HIPILER_VERSION: <HIPILER_VERSION>"; \
      echo "MULTIVEC_VERSION: <MULTIVEC_VERSION>"; \
      echo "CLODIUS_VERSION: <CLODIUS_VERSION>"; \
      echo "TIME_INTERVAL_TRACK_VERSION: <TIME_INTERVAL_TRACK_VERSION>"; \
      echo "LINEAR_LABELS_TRACK: <LINEAR_LABELS_TRACK>"; \
      echo "LABELLED_POINTS_TRACK: <LABELLED_POINTS_TRACK>"; \
      ) \
    > higlass-app/version.txt

# Setup supervisord and nginx
USER root

COPY nginx.conf /etc/nginx/
COPY sites-enabled/* /etc/nginx/sites-enabled/

COPY uwsgi_params higlass-server/
COPY default-viewconf-fixture.xml higlass-server/

COPY supervisord.conf .
COPY uwsgi.ini .
# Helper scripts
COPY *.sh ./


RUN rm /etc/nginx/sites-*/default && grep 'listen' /etc/nginx/sites-*/*
# Without this, two config files are trying to grab port 80:
# nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)


EXPOSE 80

ENV HIGLASS_SERVER_BASE_DIR /data
VOLUME /data

ARG WORKERS
ENV WORKERS ${WORKERS}
RUN echo "WORKERS: $WORKERS"

# TODO: Needs to write to logs, but running as root is risky
# Given as list so that an extra shell does not need to be started.
CMD ["supervisord", "-n"]
