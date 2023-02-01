FROM python:3.8-slim

ENV PROJECT_DIR prediction_monitoring_pattern
WORKDIR /${PROJECT_DIR}
ADD ./requirements.job.txt /${PROJECT_DIR}/
RUN apt-get -y update && \
    apt-get -y --no-install-recommends install \
    apt-utils \
    gcc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    pip install --no-cache-dir -r requirements.job.txt

COPY ./job/ /${PROJECT_DIR}/job/
CMD [ "python", "-m", "job.main" ]
