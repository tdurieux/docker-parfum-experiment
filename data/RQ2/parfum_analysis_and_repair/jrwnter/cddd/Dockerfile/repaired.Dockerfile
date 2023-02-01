FROM tensorflow/tensorflow:1.10.1-gpu-py3
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"

RUN apt-get update && apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*

RUN apt-get install -y --no-install-recommends python-rdkit librdkit1 rdkit-data && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir scikit-learn
COPY . ./

RUN pip install --no-cache-dir .