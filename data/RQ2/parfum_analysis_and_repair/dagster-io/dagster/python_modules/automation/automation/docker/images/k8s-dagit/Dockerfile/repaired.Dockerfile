ARG BASE_IMAGE
FROM "${BASE_IMAGE}"

ARG DAGSTER_VERSION

RUN pip install --no-cache-dir \
    dagster==${DAGSTER_VERSION} \
    dagster-graphql==${DAGSTER_VERSION} \
    dagster-postgres==${DAGSTER_VERSION} \
    dagster-celery[flower,redis,kubernetes]==${DAGSTER_VERSION} \
    dagster-aws==${DAGSTER_VERSION} \
    dagster-k8s==${DAGSTER_VERSION} \
    dagster-celery-k8s==${DAGSTER_VERSION} \
    dagit==${DAGSTER_VERSION}
