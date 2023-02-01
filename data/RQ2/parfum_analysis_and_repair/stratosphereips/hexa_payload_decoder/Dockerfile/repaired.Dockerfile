FROM python:3.9-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV DESTINATION_DIR /hexpayloaddecoder

RUN apt-get update && \
    apt-get install --no-install-recommends -y tshark && rm -rf /var/lib/apt/lists/*;

COPY . ${DESTINATION_DIR}/

WORKDIR ${DESTINATION_DIR}

RUN pip install --no-cache-dir -r requirements.txt
