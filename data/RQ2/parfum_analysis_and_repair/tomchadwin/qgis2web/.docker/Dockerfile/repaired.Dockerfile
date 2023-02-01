ARG QGIS_TEST_VERSION=release-3_4
FROM  qgis/qgis:${QGIS_TEST_VERSION}
MAINTAINER Matthias Kuhn <matthias@opengis.ch>
ARG QGIS_TEST_VERSION

RUN apt-get update && \
    apt-get -y --no-install-recommends install python3-pyqt5.qtwebkit libqt5webkit5-dev && rm -rf /var/lib/apt/lists/*;

ENV LANG=C.UTF-8

WORKDIR /
