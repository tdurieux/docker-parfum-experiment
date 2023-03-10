FROM ubuntu:20.04

# NOTE: Versions have been pinned everywhere. These are the latest versions at the moment, because
# I want to ensure predictable behavior, but I don't know of any problems with higher versions:
# It would be good to update these over time.

ARG DEBIAN_FRONTEND=noninteractive

# "pip install clodius" complained about missing gcc,
# and "apt-get install gcc" failed and suggested apt-get update.
# (Was having some trouble with installs, so split it up for granular caching.)
RUN apt-get update && apt-get install --no-install-recommends -y \
        unzip \
        uwsgi-plugin-python3 \
        zlib1g-dev \
        libcurl4-openssl-dev \
        g++ \
        vim \
        build-essential \
        libpng-dev \
        libjpeg-dev \
        libssl-dev \
        fuse \
        nginx=1.18.0-0ubuntu1.3 \
        supervisor \
        python3-dev \
        python3-pip \
        curl \
        git-core \
        wget \
        bzip2 \
        libbz2-dev \
        liblzma-dev \
        libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 \
        libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 \
        libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 \
        libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \
        libnss3 \
    && rm -rf /var/lib/apt/lists/*

RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash \
    && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN ln -s /usr/bin/python3 /usr/local/bin/python \
    && pip3 install --no-cache-dir --upgrade pip

RUN pip install --no-cache-dir cython numpy==1.22.1 pysam uwsgi scipy

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
RUN pip install --no-cache-dir pyBigWig
# Version 0.10.1 does not build with Python 3.6 so we have to stick to 0.10.0
RUN pip install --no-cache-dir cytoolz==0.10.1
# This is *not* tagged: The idea here is *not* to bust the cache on every minor version.
RUN wget https://raw.githubusercontent.com/higlass/higlass-server/v<SERVER_VERSION>/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install clodius==<CLODIUS_VERSION>
RUN pip install pybbi==<PYBBI_VERSION>
RUN pip install --no-cache-dir numpy==1.22.1

WORKDIR /home/higlass/projects
RUN chown higlass:higlass .
USER higlass
RUN git clone --depth 1 https://github.com/higlass/higlass-server.git --branch v<SERVER_VERSION>
RUN git clone https://github.com/vishnubob/wait-for-it.git
USER root

WORKDIR /home/higlass/projects/higlass-server
RUN python manage.py collectstatic --noinput -c

WORKDIR /home/higlass/projects
USER higlass

# Setup application (includes client js)
ENV HIPILER_REPO hipiler
RUN wget -O hipiler.zip https://github.com/flekschas/$HIPILER_REPO/releases/download/v<HIPILER_VERSION>/build.zip
RUN unzip hipiler.zip -d hipiler

ENV WEB_APP_REPO higlass-app
RUN wget -O higlass-app.zip https://github.com/higlass/$WEB_APP_REPO/releases/download/v<WEB_APP_VERSION>/build.zip
RUN unzip higlass-app.zip -d higlass-app
RUN wget -O higlass-app/hglib.min.js https://unpkg.com/higlass@<LIBRARY_VERSION>/dist/hglib.min.js
RUN wget -O higlass-app/hglib.min.css https://unpkg.com/higlass@<LIBRARY_VERSION>/dist/hglib.css

RUN wget -O higlass-app/higlass-multivec.min.js https://unpkg.com/higlass-multivec@<MULTIVEC_VERSION>/dist/higlass-multivec.min.js
RUN wget -O higlass-app/higlass-time-interval-track.min.js https://unpkg.com/higlass-time-interval-track@<TIME_INTERVAL_TRACK_VERSION>/dist/higlass-time-interval-track.min.js
RUN wget -O higlass-app/higlass-linear-labels-track.min.js https://unpkg.com/higlass-linear-labels-track@<LINEAR_LABELS_TRACK_VERSION>/dist/higlass-linear-labels-track.min.js
RUN wget -O higlass-app/higlass-labelled-points-track.min.js https://unpkg.com/higlass-labelled-points-track@<LABELLED_POINTS_TRACK_VERSION>/dist/higlass-labelled-points-track.min.js

RUN wget -O higlass-app/higlass-bedlike-triangles-track.min.js https://unpkg.com/higlass-bedlike-triangles-track@<BEDLIKE_TRIANGLES_TRACK_VERSION>/dist/higlass-bedlike-triangles-track.min.js

RUN wget -O higlass-app/higlass-range.min.js https://unpkg.com/higlass-range@<RANGE_TRACK_VERSION>/dist/higlass-range.min.js

RUN wget -O higlass-app/higlass-arcs.min.js https://unpkg.com/higlass-arcs@<ARCS_VERSION>/dist/higlass-arcs.min.js

RUN wget -O higlass-app/higlass-pileup.min.js https://unpkg.com/higlass-pileup@<PILEUP_VERSION>/dist/higlass-pileup.min.js
RUN wget -O higlass-app/higlass-dynseq.min.js https://unpkg.com/higlass-dynseq@<DYNSEQ_VERSION>/dist/higlass-dynseq.umd.js
RUN wget -O higlass-app/higlass-multi-tileset.min.js https://unpkg.com/higlass-multi-tileset@0.1.1/dist/higlass-multi-tileset.umd.js
RUN wget -O higlass-app/0.higlass-pileup.min.worker.js https://unpkg.com/higlass-pileup@<PILEUP_VERSION>/dist/0.higlass-pileup.min.worker.js

RUN wget -O higlass-app/higlass-transcripts.min.js https://unpkg.com/higlass-transcripts@<TRANSCRIPTS_VERSION>/dist/higlass-transcripts.js
RUN wget -O higlass-app/higlass-text.min.js https://unpkg.com/higlass-text@<TEXT_VERSION>/dist/higlass-text.js
RUN wget -O higlass-app/higlass-sequence.min.js https://unpkg.com/higlass-sequence@<SEQUENCE_VERSION>/dist/higlass-sequence.js
RUN wget -O higlass-app/higlass-clinvar.min.js https://unpkg.com/higlass-clinvar@<CLINVAR_VERSION>/dist/higlass-clinvar.js
RUN wget -O higlass-app/higlass-orthologs.min.js https://unpkg.com/higlass-orthologs@<ORTHOLOGS_VERSION>/dist/higlass-orthologs.js

RUN sed -i -e 's#<script src="/hglib.min.js"></script>#<script src="/higlass-multivec.min.js"></script><script src="/hglib.min.js"></script>#' higlass-app/index.html
RUN sed -i -e 's#<script src="/hglib.min.js"></script>#<script src="/higlass-time-interval-track.min.js"></script><script src="/hglib.min.js"></script>#' higlass-app/index.html
RUN sed -i -e 's#<script src="/hglib.min.js"></script>#<script src="/higlass-linear-labels-track.min.js"></script><script src="/hglib.min.js"></script>#' higlass-app/index.html
RUN sed -i -e 's#<script src="/hglib.min.js"></script>#<script src="/higlass-labelled-points-track.min.js"></script><script src="/hglib.min.js"></script>#' higlass-app/index.html
RUN sed -i -e 's#<script src="/hglib.min.js"></script>#<script src="/higlass-range.min.js"></script><script src="/hglib.min.js"></script>#' higlass-app/index.html

RUN sed -i -e 's#<script src="/hglib.min.js"></script>#<script src="/higlass-arcs.min.js"></script><script src="/hglib.min.js"></script>#' higlass-app/index.html

RUN sed -i -e 's#<script src="/hglib.min.js"></script>#<script src="/higlass-pileup.min.js"></script><script src="/hglib.min.js"></script>#' higlass-app/index.html

RUN sed -i -e 's#<script src="/hglib.min.js"></script>#<script src="/higlass-dynseq.min.js"></script><script src="/hglib.min.js"></script>#' higlass-app/index.html
RUN sed -i -e 's#<script src="/hglib.min.js"></script>#<script src="/higlass-multi-tileset.min.js"></script><script src="/hglib.min.js"></script>#' higlass-app/index.html

RUN sed -i -e 's#<script src="/hglib.min.js"></script>#<script src="/higlass-transcripts.min.js"></script><script src="/hglib.min.js"></script>#' higlass-app/index.html
RUN sed -i -e 's#<script src="/hglib.min.js"></script>#<script src="/higlass-text.min.js"></script><script src="/hglib.min.js"></script>#' higlass-app/index.html
RUN sed -i -e 's#<script src="/hglib.min.js"></script>#<script src="/higlass-sequence.min.js"></script><script src="/hglib.min.js"></script>#' higlass-app/index.html
RUN sed -i -e 's#<script src="/hglib.min.js"></script>#<script src="/higlass-clinvar.min.js"></script><script src="/hglib.min.js"></script>#' higlass-app/index.html
RUN sed -i -e 's#<script src="/hglib.min.js"></script>#<script src="/higlass-orthologs.min.js"></script><script src="/hglib.min.js"></script>#' higlass-app/index.html

RUN ( echo "SERVER_VERSION: <SERVER_VERSION>"; \
      echo "WEB_APP_VERSION: <WEB_APP_VERSION>"; \
      echo "LIBRARY_VERSION: <LIBRARY_VERSION>"; \
      echo "HIPILER_VERSION: <HIPILER_VERSION>"; \
      echo "MULTIVEC_VERSION: <MULTIVEC_VERSION>"; \
      echo "CLODIUS_VERSION: <CLODIUS_VERSION>"; \
      echo "TIME_INTERVAL_TRACK_VERSION: <TIME_INTERVAL_TRACK_VERSION>"; \
      echo "LINEAR_LABELS_TRACK: <LINEAR_LABELS_TRACK_VERSION>"; \
      echo "LABELLED_POINTS_TRACK: <LABELLED_POINTS_TRACK_VERSION>"; \
      echo "BEDLIKE_TRIANGLES_TRACK_VERSION: <BEDLIKE_TRIANGLES_TRACK_VERSION>"; \
      echo "RANGE_TRACK_VERSION: <RANGE_TRACK_VERSION>"; \
      echo "PILEUP_VERSION: <PILEUP_VERSION>"; \
      echo "TRANSCRIPTS_VERSION: <TRANSCRIPTS_VERSION>"; \
      echo "TEXT_VERSION: <TEXT_VERSION>"; \
      echo "SEQUENCE_VERSION: <SEQUENCE_VERSION>"; \
      echo "CLINVAR_VERSION: <CLINVAR_VERSION>"; \
      echo "ORTHOLOGS_VERSION: <ORTHOLOGS_VERSION>"; \
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

RUN pip install --no-cache-dir pyppeteer

# TODO: Needs to write to logs, but running as root is risky
# Given as list so that an extra shell does not need to be started.
CMD ["supervisord", "-n"]
