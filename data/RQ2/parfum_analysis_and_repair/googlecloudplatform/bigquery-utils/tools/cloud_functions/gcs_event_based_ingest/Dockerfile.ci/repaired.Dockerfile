FROM python:3.8
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        apt-transport-https \
        ca-certificates \
        curl \
        sudo \
        unzip \
    && apt-get autoremove -yqq --purge \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
WORKDIR /ci
COPY requirements.txt requirements-dev.txt ./
COPY scripts/install_terraform.sh ./
RUN ./install_terraform.sh \
    && pip3 install --no-cache-dir -r requirements-dev.txt
ENTRYPOINT ["python3", "-m", "pytest"]