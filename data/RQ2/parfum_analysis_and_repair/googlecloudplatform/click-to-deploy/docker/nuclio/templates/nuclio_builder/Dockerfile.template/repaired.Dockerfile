{{- $nuclio := index .Packages "nuclio" -}}
FROM gcr.io/cloud-builders/docker

ENV NUCLIO_VERSION={{ $nuclio.Version }}
ENV NUCLIO_LABEL={{ $nuclio.Version }}
ENV NUCLIO_DOCKER_REPO=local

RUN git clone https://github.com/nuclio/nuclio.git /src/nuclio/ \
    && cd /src/nuclio/ \
    && git checkout $NUCLIO_VERSION

RUN apt-get update && apt-get install --no-install-recommends make golang -y && rm -rf /var/lib/apt/lists/*;

COPY patch /src/nuclio

WORKDIR /src/nuclio

RUN patch --verbose -p1 < patch

COPY docker-entrypoint.sh /entrypoint.sh

COPY scripts /scripts

ENTRYPOINT ["/entrypoint.sh"]
