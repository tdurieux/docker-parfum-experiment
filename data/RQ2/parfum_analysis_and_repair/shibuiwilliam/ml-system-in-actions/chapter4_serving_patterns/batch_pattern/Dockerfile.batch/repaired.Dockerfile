FROM python:3.8-slim

ENV PROJECT_DIR batch_pattern
WORKDIR /${PROJECT_DIR}
ADD ./requirements.txt /${PROJECT_DIR}/
RUN apt-get -y update && \
    apt-get -y --no-install-recommends install \
    apt-utils \
    gcc \
    curl \
    libmariadb-dev \
    default-mysql-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    pip install --no-cache-dir -r requirements.txt

COPY ./src/ /${PROJECT_DIR}/src/
COPY ./models/ /${PROJECT_DIR}/models/

ENV MODEL_FILEPATH /${PROJECT_DIR}/models/iris_svc.onnx
ENV LABEL_FILEPATH /${PROJECT_DIR}/models/label.json
ENV SAMPLE_DATA_PATH /${PROJECT_DIR}/models/data.json
ENV LOG_LEVEL DEBUG
ENV LOG_FORMAT TEXT


CMD [ "python", "-m", "src.task.job" ]
