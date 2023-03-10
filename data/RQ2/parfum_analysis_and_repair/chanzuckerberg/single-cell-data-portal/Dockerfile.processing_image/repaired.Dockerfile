ARG BASE_TAG=branch-main

# Note: versions after 20211215 will have a Seurat version which is incompatible with our code
# Do not change this until the underlying issue is fixed
FROM ghcr.io/chanzuckerberg/corpora-upload-base:20211215
# Install cellxgene so we get the remote server that has the converter in it
# The cellxgene install script expects executables named python and pip, not python3 and pip3
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1 \
  && update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1

# For lighter weight Docker images
ENV PIP_NO_CACHE_DIR=1

# Install python dependencies
# Remove packaging dependency once pyparser>3 is supported.
RUN pip3 install --no-cache-dir scanpy==1.6.0 python-igraph==0.8.3 louvain==0.7.0 packaging==21.0 awscli


ADD requirements.txt requirements.txt
ADD backend/corpora/api_server/requirements.txt backend/corpora/api_server/requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

ADD tests /single-cell-data-portal/tests
ADD backend/__init__.py backend/__init__.py
ADD backend/corpora/__init__.py backend/corpora/__init__.py
ADD backend/corpora/dataset_processing backend/corpora/dataset_processing
ADD backend/corpora/common backend/corpora/common

ARG HAPPY_BRANCH="unknown"
ARG HAPPY_COMMIT=""
LABEL branch=${HAPPY_BRANCH}
LABEL commit=${HAPPY_COMMIT}
ENV COMMIT_SHA=${HAPPY_COMMIT}
ENV COMMIT_BRANCH=${HAPPY_BRANCH}

CMD ["python3", "-m", "backend.corpora.dataset_processing.process"]
