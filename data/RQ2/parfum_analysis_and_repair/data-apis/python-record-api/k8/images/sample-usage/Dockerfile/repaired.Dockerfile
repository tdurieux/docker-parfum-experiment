ARG FROM
FROM ${FROM}

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --no-cache-dir numpy

ENV PYTHON_RECORD_API_FROM_MODULES=record_api.sample_usage
CMD [ "python", "-m", "record_api" ]