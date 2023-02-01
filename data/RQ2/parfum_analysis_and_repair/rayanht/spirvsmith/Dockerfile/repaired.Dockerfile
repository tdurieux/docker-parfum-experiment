FROM python:3.10-slim

RUN apt-get update
RUN apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install jq && rm -rf /var/lib/apt/lists/*;

RUN mkdir /app
COPY . /app
WORKDIR /app

ENV PYTHONPATH=${PYTHONPATH}:${PWD}

RUN pip3 install --no-cache-dir poetry==1.1.13
RUN poetry config virtualenvs.create false
RUN poetry install --no-dev
ENTRYPOINT [ "sh", "scripts/run_cloud.sh" ]
