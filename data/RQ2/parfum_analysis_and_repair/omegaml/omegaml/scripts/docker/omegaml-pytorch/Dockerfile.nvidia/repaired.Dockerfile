# build a jupyterhub launchable pytorch image
# pytorch (c) Facebook Inc
# nvidia, cuda distributables (c) NVIDIA Inc, EULA
# omegaml (c) one2seven GmbH, Apache License 2.0
# see https://github.com/pytorch/pytorch/blob/master/LICENSE
#     https://docs.nvidia.com/deeplearning/frameworks/pytorch-release-notes/rel_20-03.html#rel_20-03
#     https://ngc.nvidia.com/catalog/containers/nvidia:pytorch
#     https://docs.nvidia.com/cuda/eula/index.html
#     https://github.com/omegaml/omegaml
FROM nvcr.io/nvidia/pytorch:20.03-py3
ARG  pypi="https://pypi.org/simple"
ENV  pypi=$pypi
# system install
USER root
COPY . /app
RUN pip install --no-cache-dir --upgrade pip -q
RUN pip install --no-cache-dir -f /app/packages -i $pypi --extra-index-url https://pypi.org/simple/ --pre omegaml[hdf,graph,dashserve,sql,iotools,streaming] jupyterhub jupyterlab
RUN /app/scripts/setupnb.sh
USER $NB_UID
