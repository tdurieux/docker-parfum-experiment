FROM mongo:3.4

COPY bootstrap.py test.py /

RUN apt update && \
    apt install --no-install-recommends -y python python-pip build-essential python-dev && \
    pip install --no-cache-dir pymongo dumb-init && \
    apt purge -y build-essential python-dev && rm -rf /var/lib/apt/lists/*;
