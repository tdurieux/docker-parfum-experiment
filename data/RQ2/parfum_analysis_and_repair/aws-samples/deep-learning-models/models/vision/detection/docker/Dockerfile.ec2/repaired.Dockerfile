FROM 763104351884.dkr.ecr.us-east-1.amazonaws.com/tensorflow-training:2.2.0-gpu-py37-cu101-ubuntu18.04

RUN pip uninstall -y numpy

RUN pip install --no-cache-dir tensorflow_addons \
                s3fs \
                ipykernel \
                imgaug \
                tqdm \
                tensorflow_datasets \
                scikit-image \
                cython \
                addict \
                terminaltables \
                numba && \
    pip install --no-cache-dir numpy==1.17.5 pycocotools

CMD ["bin/bash"]

