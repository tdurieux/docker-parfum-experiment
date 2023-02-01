FROM python:3.9-slim

RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential git && rm -rf /var/lib/apt/lists/*;

ENV CURL_CA_BUNDLE /etc/ssl/certs/ca-certificates.crt

WORKDIR /opt/src

COPY pcstac /opt/src/pcstac
COPY pccommon /opt/src/pccommon
RUN pip install --no-cache-dir -e ./pccommon -e

ENV APP_HOST=0.0.0.0
ENV APP_PORT=81

CMD uvicorn pcstac.main:app --host ${APP_HOST} --port ${APP_PORT} --log-level info
