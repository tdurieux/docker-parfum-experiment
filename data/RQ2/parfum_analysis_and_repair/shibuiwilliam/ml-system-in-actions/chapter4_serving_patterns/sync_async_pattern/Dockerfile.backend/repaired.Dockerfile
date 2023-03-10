FROM python:3.8-slim

ENV PROJECT_DIR sync_async_pattern
WORKDIR /${PROJECT_DIR}
ADD ./requirements_backend.txt /${PROJECT_DIR}/
RUN apt-get -y update && \
    apt-get -y --no-install-recommends install apt-utils gcc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    pip install --no-cache-dir -r requirements_backend.txt

COPY ./src/ /${PROJECT_DIR}/src/
COPY ./data/ /${PROJECT_DIR}/data/

ENV LOG_LEVEL DEBUG
ENV LOG_FORMAT TEXT

CMD [ "python", "-m", "src.api_composition_proxy.backend.prediction_batch" ]
