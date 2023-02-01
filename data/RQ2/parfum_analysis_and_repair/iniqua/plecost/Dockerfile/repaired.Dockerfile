FROM python:3.6-slim

RUN apt-get update && \
    apt-get install --no-install-recommends -y python3-lxml && rm -rf /var/lib/apt/lists/*;


RUN /usr/local/bin/python -m pip install -U pip && \
    /usr/local/bin/python -m pip install plecost


ENTRYPOINT ["/usr/local/bin/plecost"]