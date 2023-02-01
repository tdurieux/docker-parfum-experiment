#FROM tensorflow/tensorflow:nightly-gpu-py3
FROM tensorflow/tensorflow:latest-gpu-py3

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        python3-tk && rm -rf /var/lib/apt/lists/*;

# Install tesseract 4.00 LSTM version
RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common && add-apt-repository -y ppa:alex-p/tesseract-ocr && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y tesseract-ocr && rm -rf /var/lib/apt/lists/*;

# Dependencies
RUN apt-get install --no-install-recommends -y protobuf-compiler python-pil python-lxml && \
    pip install --no-cache-dir jupyter && \
    pip install --no-cache-dir matplotlib && \
    pip install --no-cache-dir lxml && \
    pip install --no-cache-dir pytesseract && rm -rf /var/lib/apt/lists/*;

# Get the models from Tensorflow models
RUN apt-get install --no-install-recommends -y git && cd / && \
    git clone https://github.com/tensorflow/models && cd /models/research && \
    protoc object_detection/protos/*.proto --python_out=. && rm -rf /var/lib/apt/lists/*;

# Install OpenCV
RUN git clone https://github.com/opencv/opencv.git && \
	cd opencv && \
	mkdir build && \
	cd build && \
	cmake .. -DWITH_FFMPEG=ON && \
	make -j20 && make install

# Install vim for text editing inside container
RUN apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;

# Modify /models/research/object_detection/eval.py to run on cpu to avoid gpu conflict
RUN sed -i '1i import os\nos.environ["CUDA_VISIBLE_DEVICES"]=""\n' /models/research/object_detection/eval.py

# Expose port, copy local code into container, start jupyter
ENV PYTHONPATH /models:/models/research:/models/research/slim:/models/research/object_detection
#EXPOSE 8888
COPY . /prog
WORKDIR /prog
ENTRYPOINT ["/usr/local/bin/jupyter","notebook"]
CMD ["--allow-root","--port=8888","--ip=0.0.0.0","--no-browser"]
