FROM nvcr.io/nvidia/tensorrt:21.03-py3

RUN apt-get update && apt-get install --no-install-recommends -y gogoprotobuf libprotobuf-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir onnx==1.4.1
