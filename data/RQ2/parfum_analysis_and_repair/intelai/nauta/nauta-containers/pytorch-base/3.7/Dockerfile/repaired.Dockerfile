ARG METRICS_IMAGE
FROM ${METRICS_IMAGE} as metrics

FROM python:3.7-slim

ENV PYTHONUNBUFFERED 1

WORKDIR /root

COPY --from=metrics /build-output/experiment_metrics-*.tar.gz /
RUN pip install --no-cache-dir --ignore-installed /experiment_metrics-*.tar.gz

ADD requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt
