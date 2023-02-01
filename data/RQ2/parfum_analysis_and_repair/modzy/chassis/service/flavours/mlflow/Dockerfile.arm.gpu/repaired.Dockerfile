# The context is /workspace, which contains:
# - flavours
#   - mlflow

# The context is /workspace, which contains:
# - flavours
#   - mlflow

FROM saumild13/l4t-jetson-chassis

RUN [ "cross-build-start" ]

# At the moment it's always model.
ARG MODEL_DIR
# Should be: mlflow.
ARG MODEL_CLASS
# Interface.
ARG INTERFACE
# This is the model.yaml file.
ARG MODZY_METADATA_PATH

WORKDIR /app

COPY flavours/${MODEL_CLASS}/${MODEL_DIR}/requirements.txt ./user_requirements.txt

RUN apt-get update && apt-get install -y --no-install-recommends libffi-dev && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -r user_requirements.txt

ARG MODEL_NAME

WORKDIR /app

COPY flavours/${MODEL_CLASS}/${MODEL_DIR} ./model/${MODEL_NAME}
COPY flavours/${MODEL_CLASS}/entrypoint.sh /

ENV MODEL_DIR ./model/${MODEL_NAME}
ENV INTERFACE ${INTERFACE}

COPY flavours/${MODEL_CLASS}/requirements_arm_gpu.txt .

RUN pip3 install --no-cache-dir -r requirements_arm_gpu.txt

COPY flavours/${MODEL_CLASS}/app.py .
COPY flavours/${MODEL_CLASS}/interfaces ./interfaces

# Overwrite the default one.
COPY ${MODZY_METADATA_PATH} ./interfaces/modzy/asset_bundle/0.1.0/model.yaml

RUN [ "cross-build-end" ]

ENTRYPOINT ["python3", "app.py"]
