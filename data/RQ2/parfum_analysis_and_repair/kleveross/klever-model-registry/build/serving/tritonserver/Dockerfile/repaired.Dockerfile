FROM nvcr.io/nvidia/tritonserver:20.09-py3

COPY scripts/serving/tensorrt /

RUN apt update \
    && apt install --no-install-recommends -y python3.6 \
    && apt install --no-install-recommends -y python3-pip \
    && pip3 install --no-cache-dir -r /requirements.txt \
    && rm /requirements.txt && rm -rf /var/lib/apt/lists/*;

COPY scripts/serving/wrapper /opt/wrapper

ENTRYPOINT ["/entrypoint.sh"]
