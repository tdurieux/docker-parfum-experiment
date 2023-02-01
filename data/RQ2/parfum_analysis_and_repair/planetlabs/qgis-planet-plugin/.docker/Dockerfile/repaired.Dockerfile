ARG QGIS_TEST_VERSION=latest
FROM  qgis/qgis:${QGIS_TEST_VERSION}

RUN apt-get update && \
    apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
COPY ./requirements.txt /tmp/
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

COPY ./requirements_test.txt /tmp/
RUN pip3 install --no-cache-dir -r /tmp/requirements_test.txt

ENV LANG=C.UTF-8
ENV IS_DOCKER_CONTAINER=true

WORKDIR /
