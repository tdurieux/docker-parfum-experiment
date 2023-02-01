FROM python:3.8.13-buster

RUN apt update && \
    apt install -y --no-install-recommends \
    curl \
    jq \
    tini && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
RUN curl -f -O https://download.docker.com/linux/static/stable/$(uname -m)/docker-20.10.9.tgz && \
    tar -xzf docker-20.10.9.tgz && \
    mv docker/* /usr/bin/ && \
    rm -rf docker docker-20.10.9.tgz

WORKDIR /app
COPY . .
RUN python3 -m pip install --no-cache-dir --progress-bar off -U pip setuptools wheel && \
    python3 -m pip install --no-cache-dir --progress-bar off -e .[tests]

ENV SAPPORO_HOST 0.0.0.0
ENV SAPPORO_PORT 1122
ENV SAPPORO_DEBUG True

EXPOSE 1122

ENTRYPOINT ["tini", "--"]
CMD ["sleep", "infinity"]
