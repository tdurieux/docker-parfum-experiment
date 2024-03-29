FROM python:3.8-slim as builder

ARG SERVER_DIR=resnet50_onnx_runtime
ENV PROJECT_DIR prep_pred_pattern

WORKDIR /${PROJECT_DIR}
ADD ./${SERVER_DIR}/requirements.txt /${PROJECT_DIR}/

COPY ./${SERVER_DIR}/extract_resnet50_onnx.py /${PROJECT_DIR}/extract_resnet50_onnx.py
COPY ./src/ml/transformers.py /${PROJECT_DIR}/src/ml/transformers.py
COPY ./data/cat.jpg /${PROJECT_DIR}/data/cat.jpg
COPY ./data/image_net_labels.json /${PROJECT_DIR}/data/image_net_labels.json

RUN apt-get -y update && \
    apt-get -y --no-install-recommends install apt-utils gcc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    pip install --no-cache-dir -r requirements.txt && \
    touch __init__.py && \
    touch src/__init__.py && \
    touch src/ml/__init__.py && \
    python -m extract_resnet50_onnx --prep

FROM python:3.8-slim

ENV PROJECT_DIR prep_pred_pattern
ENV MODEL_BASE_PATH=/${PROJECT_DIR}/models

WORKDIR /${PROJECT_DIR}
ADD ./requirements.txt /${PROJECT_DIR}/
RUN apt-get -y update && \
    apt-get -y --no-install-recommends install apt-utils gcc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    pip install --no-cache-dir -r requirements.txt

COPY ./src/ /${PROJECT_DIR}/src/
COPY --from=builder /${MODEL_BASE_PATH}/preprocess_transformer.pkl ${MODEL_BASE_PATH}/preprocess_transformer.pkl
COPY --from=builder /${MODEL_BASE_PATH}/softmax_transformer.pkl ${MODEL_BASE_PATH}/softmax_transformer.pkl
COPY ./data/cat.jpg /${PROJECT_DIR}/data/cat.jpg
COPY ./data/image_net_labels.json /${PROJECT_DIR}/data/image_net_labels.json

ENV PREPROCESS_TRANSFORMER_PATH ${MODEL_BASE_PATH}/preprocess_transformer.pkl
ENV SOFTMAX_TRANSFORMER_PATH ${MODEL_BASE_PATH}/softmax_transformer.pkl
ENV SAMPLE_IMAGE_PATH /${PROJECT_DIR}/data/cat.jpg
ENV LABEL_PATH /${PROJECT_DIR}/data/image_net_labels.json

ENV LOG_LEVEL DEBUG
ENV LOG_FORMAT TEXT

COPY ./run.sh /${PROJECT_DIR}/run.sh
RUN chmod +x /${PROJECT_DIR}/run.sh
CMD [ "./run.sh" ]
