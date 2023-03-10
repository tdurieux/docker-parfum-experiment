FROM chainer-base:4.0.0-gpu-py2

RUN pip2 install --no-cache-dir --no-cache chainer==4.0.0 chainermn==1.2.0 chainercv==0.9.0 matplotlib==2.2.0 cupy==4.0.0 \
                            opencv-python==3.4.0.12

# Edit matplotlibrc to use "Agg" backend by default to write plots to PNG files (which some Chainer extensions do).
# https://matplotlib.org/tutorials/introductory/usage.html#what-is-a-backend
WORKDIR /usr/local/lib/python2.7/dist-packages/

RUN sed -i s/TkAgg/Agg/ matplotlib/mpl-data/matplotlibrc

# Apply patch to stop Parallel Updater from hanging
RUN git apply --verbose /parallel_updater.patch

WORKDIR /

COPY dist/sagemaker_chainer_container-1.0-py2.py3-none-any.whl /sagemaker_chainer_container-1.0-py2.py3-none-any.whl

RUN pip2 install --no-cache-dir --no-cache /sagemaker_chainer_container-1.0-py2.py3-none-any.whl

ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

ENV SAGEMAKER_TRAINING_MODULE sagemaker_chainer_container.training:main
ENV SAGEMAKER_SERVING_MODULE sagemaker_chainer_container.serving:main
