ARG BASE_IMAGE
FROM "${BASE_IMAGE}"

ARG DAGSTER_VERSION

COPY build_cache/ /

RUN pip install --no-cache-dir \
    -e dagster \
    -e dagster \
    -e dagster \
    -e dagster \
    -e dagster \
    -e dagit