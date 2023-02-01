FROM python:3.7
ENV PYTHONUNFERED 1
RUN mkdir /config; \
    mkdir /code;
COPY ./config/ /config
RUN pip install --no-cache-dir -r /config/requirements_websocket.txt; \
    apt-get update && apt-get install --no-install-recommends -y docker.io && rm -rf /var/lib/apt/lists/*;

WORKDIR /code
