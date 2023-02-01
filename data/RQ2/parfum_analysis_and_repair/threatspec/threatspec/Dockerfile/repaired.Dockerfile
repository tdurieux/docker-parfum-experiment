FROM python:3.8-buster
RUN pip3 install --no-cache-dir threatspec && apt-get update && apt-get install --no-install-recommends -y graphviz && rm -rf /var/lib/apt/lists/*
WORKDIR /data
ENTRYPOINT ["threatspec"]