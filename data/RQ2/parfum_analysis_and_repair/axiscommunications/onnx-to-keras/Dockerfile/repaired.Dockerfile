FROM tensorflow/tensorflow:1.15.2-py3
RUN pip install --no-cache-dir torch torchvision
RUN pip install --no-cache-dir pytest
RUN pip install --no-cache-dir onnx
RUN pip install --no-cache-dir onnxruntime
RUN pip install --no-cache-dir fire
RUN mkdir /code
WORKDIR /code
