FROM tensorflow/tensorflow:1.4.0

RUN mkdir -p /train/tensorflow/input_data && \
    cd  /train/tensorflow/input_data && \
    curl -f -O http://kubeflow-oss.oss-cn-hangzhou.aliyuncs.com/tensorflow/input_data/t10k-images-idx3-ubyte.gz && \
    curl -f -O http://kubeflow-oss.oss-cn-hangzhou.aliyuncs.com/tensorflow/input_data/t10k-labels-idx1-ubyte.gz && \
    curl -f -O http://kubeflow-oss.oss-cn-hangzhou.aliyuncs.com/tensorflow/input_data/train-images-idx3-ubyte.gz && \
    curl -f -O http://kubeflow-oss.oss-cn-hangzhou.aliyuncs.com/tensorflow/input_data/train-labels-idx1-ubyte.gz

COPY main.py /app/main.py

ENTRYPOINT ["python", "/app/main.py"]