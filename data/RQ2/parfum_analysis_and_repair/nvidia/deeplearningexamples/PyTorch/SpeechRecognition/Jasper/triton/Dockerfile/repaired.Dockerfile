ARG FROM_IMAGE_NAME=nvcr.io/nvidia/tritonserver:20.10-py3-clientsdk
FROM ${FROM_IMAGE_NAME}

RUN apt update && apt install --no-install-recommends -y python3-pyaudio libsndfile1 && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir -U pip
RUN pip3 install --no-cache-dir onnxruntime unidecode inflect soundfile

WORKDIR /workspace/jasper
COPY . .
