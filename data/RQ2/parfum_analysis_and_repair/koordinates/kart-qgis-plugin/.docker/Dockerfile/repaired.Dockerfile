ARG QGIS_TEST_VERSION=latest
FROM  qgis/qgis:${QGIS_TEST_VERSION}

RUN apt-get update && \
    apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
COPY ./requirements.txt /tmp/
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

COPY ./requirements_test.txt /tmp/
RUN pip3 install --no-cache-dir -r /tmp/requirements_test.txt

RUN apt-get install -y --no-install-recommends wget && rm -rf /var/lib/apt/lists/*;
RUN wget -nv https://github.com/koordinates/kart/releases/download/v0.10.7/kart_0.10.7-1_amd64.deb
RUN apt install -y --no-install-recommends -q ./kart_0.10.7-1_amd64.deb && rm -rf /var/lib/apt/lists/*;

ENV LANG=C.UTF-8

WORKDIR /
