# Dockerfile used as a template. Placeholders "$IMAGE" and "$PACKAGE" are replaced
# with their actual value by `run-tests.sh`
FROM python:$IMAGE
LABEL maintainer="Marco M. (mmicu) <mmicu.github00@gmail.com>"

COPY . /app
WORKDIR /app

RUN set -x                                   \
    && apt-get update \
    && apt-get install --no-install-recommends -y make \
    && pip install --no-cache-dir -r tests/requirements.txt \
    && pip install --no-cache-dir $PACKAGE && rm -rf /var/lib/apt/lists/*;
