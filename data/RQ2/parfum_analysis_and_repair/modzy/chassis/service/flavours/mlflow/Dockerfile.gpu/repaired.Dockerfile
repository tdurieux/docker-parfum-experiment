# The context is /workspace, which contains:
# - flavours
#   - mlflow

FROM nvidia/cuda:11.0-runtime-ubuntu20.04

# Install miniconda
RUN rm /etc/apt/sources.list.d/cuda.list
RUN apt-get update && apt-get install --no-install-recommends -y curl build-essential && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o Miniconda3-latest-Linux-x86_64.sh
RUN bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda3\
    && rm -f Miniconda3-latest-Linux-x86_64.sh
ENV PATH /opt/miniconda3/bin:$PATH

# At the moment it's always model.
ARG MODEL_DIR
# Should be: mlflow.
ARG MODEL_CLASS
# Interface.
ARG INTERFACE
# This is the model.yaml file.
ARG MODZY_METADATA_PATH

WORKDIR /app

COPY flavours/${MODEL_CLASS}/${MODEL_DIR}/conda.yaml ./conda.yaml

ENV CONDA_ENV chassis-env

# Create conda environment.
RUN conda env create --name $CONDA_ENV --file ./conda.yaml

ARG MODEL_NAME

WORKDIR /app

COPY flavours/${MODEL_CLASS}/${MODEL_DIR} ./model/${MODEL_NAME}
COPY flavours/${MODEL_CLASS}/entrypoint.sh /

ENV MODEL_DIR ./model/${MODEL_NAME}
ENV INTERFACE ${INTERFACE}

SHELL ["/bin/bash", "-c"]

COPY flavours/${MODEL_CLASS}/requirements.txt .
RUN /bin/bash -c "source activate chassis-env \
    && pip install --no-cache-dir -r requirements.txt \
    && conda deactivate"

COPY flavours/${MODEL_CLASS}/app.py .
COPY flavours/${MODEL_CLASS}/interfaces ./interfaces

# Overwrite the default one.
COPY ${MODZY_METADATA_PATH} ./interfaces/modzy/asset_bundle/0.1.0/model.yaml

ENTRYPOINT ["conda", "run", "--no-capture-output", "-n", "chassis-env", "python", "app.py"]

