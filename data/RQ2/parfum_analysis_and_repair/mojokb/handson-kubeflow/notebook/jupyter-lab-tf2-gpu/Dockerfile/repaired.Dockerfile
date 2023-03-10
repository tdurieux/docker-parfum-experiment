FROM tensorflow/tensorflow:2.0.0-gpu-py3

WORKDIR /home/jovyan

USER root

RUN pip install --no-cache-dir jupyter -U && pip install --no-cache-dir jupyterlab

RUN apt-get update && apt-get install -yq --no-install-recommends \
  apt-transport-https \
  build-essential \
  bzip2 \
  ca-certificates \
  curl \
  g++ \
  git \
  gnupg \
  graphviz \
  locales \
  lsb-release \
  openssh-client \
  sudo \
  unzip \
  vim \
  wget \
  zip \
  emacs \
  python3-pip \
  python3-dev \
  python3-setuptools \
  && apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN curl -f -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
RUN echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update
RUN apt-get install --no-install-recommends -y kubectl && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir kubeflow-fairing==0.7.2
RUN pip install --no-cache-dir kfp==0.5
RUN pip install --no-cache-dir kfserving==0.2.2
RUN pip install --no-cache-dir kubeflow-kale
RUN pip install --no-cache-dir dill
RUN pip install --no-cache-dir kubeflow-katib==0.0.2

RUN pip install --no-cache-dir jupyterlab && \
    jupyter serverextension enable --py jupyterlab --sys-prefix

ARG NB_USER=jovyan

EXPOSE 8888


ENV NB_USER $NB_USER
ENV NB_UID=1000
ENV HOME /home/$NB_USER
ENV NB_PREFIX /

CMD ["sh", "-c", "jupyter lab --notebook-dir=/home/jovyan --ip=0.0.0.0 --no-browser --allow-root --port=8888 --LabApp.token='' --LabApp.password='' --LabApp.allow_origin='*' --LabApp.base_url=${NB_PREFIX}"]
