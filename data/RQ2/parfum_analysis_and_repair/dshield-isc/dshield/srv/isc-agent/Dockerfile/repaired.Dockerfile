FROM python:3.7.12-slim-bullseye

WORKDIR /opt/sans-isc-agent

COPY . /opt/sans-isc-agent

RUN apt-get update \
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir pipenv \
    && pipenv sync --dev --system

CMD ["sh", "-c", "python main.py"]
