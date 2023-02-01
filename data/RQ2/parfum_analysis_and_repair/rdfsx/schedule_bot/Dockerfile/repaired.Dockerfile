FROM python:3.8-slim-buster
WORKDIR /src
ENV PYTHONPATH "${PYTHONPATH}:/src/"
ENV PATH "/src/scripts:${PATH}"
COPY . /src
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN python -m pip install --upgrade pip && \
    pip install --no-cache-dir poetry && \
    poetry config virtualenvs.create false && \
    poetry install
RUN chmod +x /src/scripts/*
ENTRYPOINT ["docker-entrypoint.sh"]