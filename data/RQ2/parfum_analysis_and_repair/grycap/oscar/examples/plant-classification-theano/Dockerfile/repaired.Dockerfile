FROM bitnami/minideb

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        curl \
        git \
        python-setuptools \
        python-pip \
        build-essential \
        python-dev \
        python-wheel \
        python-numpy \
        python-scipy \
        python-tk && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade https://github.com/Theano/Theano/archive/master.zip
RUN pip install --no-cache-dir --upgrade https://github.com/Lasagne/Lasagne/archive/master.zip

RUN cd /opt && \
    git clone https://github.com/indigo-dc/plant-classification-theano -b package && \
    cd plant-classification-theano && \
    pip install --no-cache-dir -e .

# Copy the classify_image script
COPY classify_image.py /opt/plant-classification-theano/classify_image.py

# Get pretrained model
ENV SWIFT_CONTAINER https://cephrgw01.ifca.es:8080/swift/v1/Plants/
ENV THEANO_TR_WEIGHTS resnet50_6182classes_100epochs.npz
ENV THEANO_TR_JSON resnet50_6182classes_100epochs.json
ENV SYNSETS synsets_binomial.txt
RUN curl -f -o /opt/plant-classification-theano/plant_classification/training_weights/${THEANO_TR_WEIGHTS} \
        ${SWIFT_CONTAINER}${THEANO_TR_WEIGHTS} && \
    curl -f -o /opt/plant-classification-theano/plant_classification/training_info/${THEANO_TR_JSON} \
        ${SWIFT_CONTAINER}${THEANO_TR_JSON} && \
    curl -f -o /opt/plant-classification-theano/data/data_splits/synsets_binomial.txt \
        ${SWIFT_CONTAINER}${SYNSETS}

