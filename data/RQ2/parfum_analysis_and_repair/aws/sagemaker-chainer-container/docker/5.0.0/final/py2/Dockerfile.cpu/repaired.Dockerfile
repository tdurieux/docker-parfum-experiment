FROM chainer-base:5.0.0-cpu-py2

LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true

RUN pip2 install --no-cache-dir --no-cache chainer==5.0.0 chainercv==0.12.0 matplotlib==2.2.0 \
    opencv-python==3.4.0.12 mpi4py==3.0.0

# Edit matplotlibrc to use "Agg" backend by default to write plots to PNG files (which some Chainer extensions do).
# https://matplotlib.org/tutorials/introductory/usage.html#what-is-a-backend
WORKDIR /usr/local/lib/python2.7/dist-packages/

RUN sed -i s/TkAgg/Agg/ matplotlib/mpl-data/matplotlibrc

WORKDIR /

COPY dist/sagemaker_chainer_container-1.0-py2.py3-none-any.whl /sagemaker_chainer_container-1.0-py2.py3-none-any.whl

RUN pip2 install --no-cache-dir --no-cache /sagemaker_chainer_container-1.0-py2.py3-none-any.whl

ENV PYTHONIOENCODING=UTF-8 \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

ENV SAGEMAKER_TRAINING_MODULE sagemaker_chainer_container.training:main
ENV SAGEMAKER_SERVING_MODULE sagemaker_chainer_container.serving:main
