FROM ubuntu:16.04

RUN apt-get update \
    && apt-get install --no-install-recommends git build-essential python python-pip python-libxmp -y \
    && git clone https://github.com/hartek/metadatos.git \
    && cd /metadatos \
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -U setuptools \
    && pip install --no-cache-dir -r requirements.txt \
    && mkdir /output && rm -rf /var/lib/apt/lists/*;

WORKDIR metadatos

VOLUME [ "/output" ]

ENTRYPOINT ["python", "metadatos.py"]
CMD ["-h"]
