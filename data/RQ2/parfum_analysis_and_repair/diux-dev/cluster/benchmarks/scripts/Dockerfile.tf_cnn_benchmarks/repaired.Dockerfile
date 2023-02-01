FROM tensorflow/tensorflow:nightly-gpu

RUN apt-get update && apt-get install --no-install-recommends -y python-pip && pip install --no-cache-dir google-cloud && rm -rf /var/lib/apt/lists/*;
COPY tf_cnn_benchmarks/ ./tf_cnn_benchmarks/
RUN touch tf_cnn_benchmarks/__init__.py
RUN mkdir ./util/
COPY util/ ./util/
ENTRYPOINT ["python", "-m", "tf_cnn_benchmarks.tf_cnn_benchmarks"]
