FROM jupyter/tensorflow-notebook

MAINTAINER lspvic <lspvic@qq.com>

RUN pip install --no-cache-dir --pre jupyter-tensorboard
