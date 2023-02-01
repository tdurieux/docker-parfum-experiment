FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install --no-install-recommends -y sudo \
    build-essential \
    curl \
    libcurl4-openssl-dev \
    libssl-dev \
    wget \
    python3-dev \
    python3-pip \
    libxrender-dev \
    libxext6 \
    libsm6 \
    openssl git && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt/service
RUN pip3 install --no-cache-dir --upgrade pip

COPY requirements.txt /opt/service
RUN pip3 install --no-cache-dir -r requirements.txt

COPY api.py /opt/service

EXPOSE 5000

ENTRYPOINT ["python3", "./api.py"]