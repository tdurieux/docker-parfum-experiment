FROM gcperkins/wpilib-ml-base

RUN curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list && \
    apt-get update && \
    apt-get install --no-install-recommends edgetpu-compiler -y && \
    mkdir -p /tensorflow/models/research/learn && \
    mkdir -p /tensorflow/models/research/learn/ckpt && \
    mkdir -p /opt/ml/model/checkpoints/ && \
    rm -rf /tensorflow/models/research/learn/train && \
    rm -rf /tensorflow/models/research/learn/models && \
    cd /tensorflow/models/research/ && \
    wget "https://github.com/wpilibsuite/DetectCoral/releases/download/v2/tflite_graph.pb" && rm -rf /var/lib/apt/lists/*;

COPY scripts /tensorflow/models/research/
WORKDIR /tensorflow/models/research/
ENTRYPOINT ["python", "-u", "export.py", "--dir"]