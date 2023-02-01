FROM tensorflow/tensorflow:nightly

WORKDIR /

RUN apt-get update && \
    apt-get install --no-install-recommends -y git && \
    mkdir /model /data && \
    git clone https://github.com/tensorflow/models.git && \
    cp -r /models/research/slim/* /model/ && \
    rm -rf /models && rm -rf /var/lib/apt/lists/*;

COPY dataset_factory.py /model/datasets/.
COPY arts.py /model/datasets/.
COPY classify.py /model/.
COPY data/ /data/

ENTRYPOINT ["python", "/model/train_image_classifier.py"]
