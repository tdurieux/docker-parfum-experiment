FROM tensorflow/tensorflow:1.15.0-gpu-py3

RUN pip install --no-cache-dir tf-encrypted

COPY encryption_test.py /encryption_test.py
