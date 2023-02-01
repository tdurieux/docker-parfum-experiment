FROM tensorflow/tensorflow
RUN pip install --no-cache-dir torch torchvision
RUN pip install --no-cache-dir pytest
RUN pip install --no-cache-dir onnx
RUN pip install --no-cache-dir onnxruntime
RUN pip install --no-cache-dir fire
RUN mkdir /code
WORKDIR /code
