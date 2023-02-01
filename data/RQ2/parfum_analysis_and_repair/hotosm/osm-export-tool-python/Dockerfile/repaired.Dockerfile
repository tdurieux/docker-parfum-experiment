FROM debian:buster-slim

RUN apt-get update && apt-get install --no-install-recommends -yq \
    python3-pip \
    python3-gdal && rm -rf /var/lib/apt/lists/*;

COPY . /source/osm-export-tool-python

RUN pip3 install --no-cache-dir /source/osm-export-tool-python

COPY bin/docker_entrypoint.sh /bin/docker_entrypoint.sh

ENTRYPOINT [ "/bin/docker_entrypoint.sh" ]
