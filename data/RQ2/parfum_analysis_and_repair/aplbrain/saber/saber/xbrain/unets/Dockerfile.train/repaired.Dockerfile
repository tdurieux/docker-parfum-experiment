# Copyright 2018 The Johns Hopkins University Applied Physics Laboratory.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM kaixhin/cuda-theano:7.5

# Install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
  libhdf5-dev \
  python-h5py \
  python-yaml \
  vim && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip
# Upgrade six
RUN pip install --no-cache-dir --upgrade six

# Clone Keras repo and move into it
#RUN cd /root && git clone https://github.com/fchollet/keras.git && cd keras && \
#  # Install
#  python setup.py install
RUN pip install --no-cache-dir --ignore-installed keras
#==1.2.2
#RUN pip install --ignore-installed pygpu
#added

# Install intern
RUN pip install --no-cache-dir --ignore-installed intern
#RUN pip install awscli
#RUN pip install boto3
RUN pip install --no-cache-dir --ignore-installed SimpleITK

# Create workspace
# TODO: Re-org this to use git clone and S3
WORKDIR /src
#COPY ./weights/*.hdf5 /src/weights/
#COPY ./aws-batch/setup/startup.sh /src/
#COPY ./*.json /src/
COPY ./*.py /src/

ENV KERAS_BACKEND=theano
ENV PATH=/src:$PATH

#BLAS FOR THEANO
RUN apt-get install --no-install-recommends -y libatlas-base-dev && rm -rf /var/lib/apt/lists/*;
#ENV THEANO_FLAGS=blas.ldflags='-lf77blas -latlas -lgfortran'

ENV DEVICE="cuda0"
ENV GPUARRAY_CUDA_VERSION=75
ENV THEANO_FLAGS="device=cuda0,blas.ldflags='-lf77blas -latlas -lgfortran',dnn.include_path=/usr/local/cuda/include"
#ENV THEANO_FLAGS='device=cuda,lib.cnmem=1'

RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;

CMD ["python", "train_unet_docker.py"]
