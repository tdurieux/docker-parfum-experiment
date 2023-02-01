FROM debian:8
ENV MIMIR_PKG_URL=https://ci.navitia.io/job/mimirsbrunn_release_package/lastSuccessfulBuild/artifact/*zip*/archive.zip
ENV COSMOGONY2CITIES_PKG_URL=https://ci.navitia.io/view/mimir/job/cosmogony2cities_deb/lastSuccessfulBuild/artifact/*zip*/archive.zip

RUN apt-get update && \
            apt-get upgrade -y && \
            apt-get install -y libpqxx-4.0 \
                                libgoogle-perftools4 \
                                libproj-dev \
                                libgeos-c1  \
                                libzmq3 \
                                libprotobuf9 \
                                liblog4cplus-1.0-4 \
                                libboost-chrono1.55.0 \
                                libboost-date-time1.55.0 \
                                libboost-filesystem1.55.0 \
                                libboost-iostreams1.55.0 \
                                libboost-program-options1.55.0 \
                                libboost-regex1.55.0 \
                                libboost-serialization1.55.0 \
                                libboost-system1.55.0 \
                                libboost-thread1.55.0 \
                                python-dev \
                                python-pip \
                                git \
                                libgeos-c1 \
                                libpq-dev \
                                wget \
                                unzip

WORKDIR /usr/src/app

COPY navitia/source/tyr/requirements.txt /usr/src/app
COPY navitia/source/tyr/tyr /usr/src/app/tyr
COPY navitia/source/tyr/manage_tyr.py /usr/src/app/manage_tyr.py
COPY navitia/source/navitiacommon/navitiacommon /usr/src/app/navitiacommon
COPY navitia/source/sql/alembic /usr/share/navitia/ed/alembic

COPY ed/fusio2ed /usr/bin/fusio2ed
COPY ed/ed2nav /usr/bin/ed2nav
COPY ed/osm2ed /usr/bin/osm2ed
COPY ed/poi2ed /usr/bin/poi2ed
COPY ed/gtfs2ed /usr/bin/gtfs2ed
COPY ed/geopal2ed /usr/bin/geopal2ed
COPY cities/cities /usr/bin/cities

# install mimir packages
RUN wget --quiet $MIMIR_PKG_URL -O /tmp/mimir_pkg.zip && \
    unzip /tmp/mimir_pkg.zip -d /tmp && \
    dpkg -i /tmp/archive/mimirsbrunn*.deb && \
    wget --quiet $COSMOGONY2CITIES_PKG_URL -O /tmp/cosmo2cities.zip && \
    unzip /tmp/cosmo2cities.zip -d /tmp && \
    dpkg -i /tmp/archive/cosmogony2cities*.deb

RUN pip install -r /usr/src/app/requirements.txt

EXPOSE 5000

COPY tyr_settings.py /

# TODO change the user to remove this ugly C_FORCE_ROOT
ENV TYR_CONFIG_FILE=/tyr_settings.py
ENV C_FORCE_ROOT=1
CMD ["celery", "worker", "-A", "tyr.tasks", "-O", "fair"]
