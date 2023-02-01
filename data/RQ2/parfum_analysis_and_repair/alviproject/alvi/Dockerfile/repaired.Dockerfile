FROM olympus_base:latest

COPY . /

RUN apt-get update && \
    apt-get install --no-install-recommends -y python3 python3-pip && \

    pip3 install --no-cache-dir -r requirements.txt && rm -rf /var/lib/apt/lists/*;


CMD python3 -m alvi.server --port=8000
