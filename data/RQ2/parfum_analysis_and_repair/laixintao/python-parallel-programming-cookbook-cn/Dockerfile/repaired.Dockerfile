From python:3

WORKDIR /app

COPY requirements.txt ./requirements.txt

RUN pip3 install --no-cache-dir -r requirements.txt

RUN apt-get update && \
    apt-get install --no-install-recommends -y git mercurial texlive-full xzdec && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
