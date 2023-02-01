FROM tensorflow/tensorflow:1.12.0-py3

# install keras
RUN pip install --no-cache-dir \
    keras==2.2.4 \
    scikit-image

RUN pip install --no-cache-dir pytest

WORKDIR /project