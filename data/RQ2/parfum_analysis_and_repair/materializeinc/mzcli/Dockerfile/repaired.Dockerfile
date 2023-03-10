FROM python:3.8-slim-buster

COPY . /app
RUN apt-get update -o Acquire::Languages=none \
    && env DEBIAN_FRONTEND=noninteractive \
        apt-get install \
            -qy --no-install-recommends \
            -o Dpkg::Options::=--force-unsafe-io \
                libpq5 \
                libpq-dev \
                build-essential \
    && cd /app \ && pip install --no-cache-dir -e . \
    # clean up build dependencies
    && apt-get remove --purge -qy \
        libpq-dev \
        build-essential \
    && apt-get autoremove -qy \
    # the apt upstream package index gets stale very quickly
    && rm -rf \
        /var/cache/apt/archives \
        /var/lib/apt/lists/* \
        /root/.cache/pip/ \
    ;

ENTRYPOINT ["mzcli"]
CMD ["host=materialized port=6875 dbname=materialize"]
