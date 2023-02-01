FROM tensorflow/tensorflow:2.3.0

RUN pip uninstall -y protobuf && \
    pip install --no-cache-dir protobuf -i https://mirrors.tencent.com/pypi/simple && \
    pip install --no-cache-dir nni -i https://mirrors.tencent.com/pypi/simple && \
    pip install --no-cache-dir tensorflow_datasets -i https://mirrors.tencent.com/pypi/simple && \
    pip install --no-cache-dir sklearn -i https://mirrors.tencent.com/pypi/simple && \
    pip install --no-cache-dir sklearn_pandas -i https://mirrors.tencent.com/pypi/simple && \
    pip install --no-cache-dir scipy -i https://mirrors.tencent.com/pypi/simple && \
    pip install --no-cache-dir gensim -i https://mirrors.tencent.com/pypi/simple && \
    pip install --no-cache-dir prettytable -i https://mirrors.tencent.com/pypi/simple

COPY job/pkgs /app/job/pkgs
COPY job/tf_model_offline_predict/*.py /app/job/tf_model_offline_predict/

WORKDIR /app
ENTRYPOINT ["python", "-m", "job.tf_model_offline_predict.main"]