FROM python:3.8-alpine

LABEL maintainer="Dušan Maďar"

ENV APP_DIR=/usr/src/app
ENV PYTHONPATH="${PYTHONPATH}:${APP_DIR}"
WORKDIR $APP_DIR

COPY requirements.txt requirements-server.txt ./
RUN pip install --no-cache-dir -r requirements.txt -r
COPY scripts ./scripts/
COPY toripchanger ./toripchanger

ENTRYPOINT ["python", "/usr/src/app/scripts/toripchanger_server"]
