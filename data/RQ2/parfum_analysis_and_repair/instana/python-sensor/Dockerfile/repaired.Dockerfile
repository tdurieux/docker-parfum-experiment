# Development Container
FROM python:3.8.5

RUN apt update -q && apt install --no-install-recommends -qy vim && rm -rf /var/lib/apt/lists/*;

WORKDIR /python-sensor

ENV INSTANA_DEBUG=true
ENV PYTHONPATH=/python-sensor
ENV AUTOWRAPT_BOOTSTRAP=instana

COPY . ./

RUN pip install --no-cache-dir -e .
