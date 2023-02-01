ARG FROM

FROM ${FROM}

RUN apt-get update && \
    apt-get -y --no-install-recommends install pandoc && rm -rf /var/lib/apt/lists/*;
