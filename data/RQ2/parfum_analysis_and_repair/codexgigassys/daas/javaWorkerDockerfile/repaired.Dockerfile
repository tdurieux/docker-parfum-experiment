FROM python:3.7.4-buster
RUN mkdir /daas
WORKDIR /daas
COPY requirements_worker.txt /tmp/requirements_worker.txt
RUN pip install --no-cache-dir --upgrade pip && \
    pip --retries 10 --no-cache-dir install -r /tmp/requirements_worker.txt


# Generic
RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential apt-transport-https && \
    apt-get install --no-install-recommends -y gnutls-bin \
        host \
        unzip \
        xauth \
        xvfb \
        zenity \
        zlib1g \
        zlib1g-dev \
        zlibc && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean



# Install OpenJDK-11
RUN apt update && \
    echo 'deb http://ftp.de.debian.org/debian buster main' >> /etc/apt/sources.list && \
    apt update && \
    apt-get install --no-install-recommends -y openjdk-11-jdk && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean



# Downloading CFR:
RUN echo "installing cfr..." && \
    mkdir /cfr && \
    wget https://www.benf.org/other/cfr/cfr-0.148.jar -O /cfr/cfr.jar && \
    echo "cfr installed"
