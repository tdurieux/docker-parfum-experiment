FROM tensorflow/tensorflow:1.9.0-gpu

WORKDIR /

COPY ./images /images
COPY ./retrain.py /retrain.py

ENTRYPOINT [ "python","retrain.py" ]