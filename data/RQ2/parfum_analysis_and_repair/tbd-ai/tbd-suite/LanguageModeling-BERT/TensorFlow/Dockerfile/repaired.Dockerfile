FROM tensorflow/tensorflow:latest-gpu-py3
RUN apt-get update && apt-get install --no-install-recommends -y cuda-nsight-compute-10-0 && rm -rf /var/lib/apt/lists/*;