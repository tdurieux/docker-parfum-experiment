FROM pysoa-test-service

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libc6 \
        libgcc1 \
        libgssapi-krb5-2 \
        libicu-dev \
        libltdl-dev \
        liblttng-ust0 \
        libssl-dev \
        libstdc++6 \
        zlib1g && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir pytest pytz docker-compose ipdb
COPY conftest.py /srv/pysoa/
COPY tests/functional /srv/pysoa/tests/functional/

WORKDIR /srv/pysoa/
RUN  echo '#!/bin/sh\n\
exec "$@"\n\
' > /usr/local/bin/pysoa-entrypoint.sh
RUN chmod +x /usr/local/bin/pysoa-entrypoint.sh

ENV COVERAGE_FILE=/srv/run/.coverage

# The value doesn't actually matter, but it must be set to keep docker-compose from issuing a warning when called
# within this container to exec commands on other containers.
ENV DOCKER_BINARY_BIND_SOURCE=/usr/local/bin/docker

CMD ["/bin/sleep", "3600"]
