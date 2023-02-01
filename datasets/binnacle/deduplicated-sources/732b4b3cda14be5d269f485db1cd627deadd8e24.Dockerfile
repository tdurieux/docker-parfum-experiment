# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

FROM jupyter/pyspark-notebook:8015c88c4b11

RUN pip install jupyter_kernel_gateway==0.5.1

ARG IPYWIDGETS_VER
RUN pip install "ipywidgets==$IPYWIDGETS_VER"

# install Declarative Widgets python package
# don't bother activating the extension, not needed outside notebook
ARG DECLWIDGETS_VER
RUN pip install "jupyter_declarativewidgets==$DECLWIDGETS_VER"

# run kernel gateway, not notebook server
CMD ["jupyter", "kernelgateway", "--KernelGatewayApp.ip=0.0.0.0"]
