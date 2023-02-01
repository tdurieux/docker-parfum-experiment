ARG BASE_IMAGE
ARG PYTHON_VERSION

FROM "${BASE_IMAGE}"

# Prevent telemetry from being sent in image
ENV DAGSTER_DISABLE_TELEMETRY=true

COPY . .

RUN pip install --no-cache-dir \
    -e modules/dagster \
    -e .

WORKDIR /dagster_test/dagster_core_docker_buildkite/

EXPOSE 80
