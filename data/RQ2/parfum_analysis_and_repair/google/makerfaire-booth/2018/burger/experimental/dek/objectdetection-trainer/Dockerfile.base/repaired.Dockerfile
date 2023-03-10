ARG TF_TAG
FROM tensorflow/tensorflow${TF_TAG}

RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    mkdir -p /opt && \
    git clone https://github.com/dakoner/models-1.git --depth 1 /opt/tensorflow_models && \
    apt-get clean && rm -rf /tmp/* /var/tmp/* && rm -rf /var/lib/apt/lists/*;
COPY scripts/*.sh /opt
