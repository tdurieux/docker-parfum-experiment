FROM nvcr.io/nvidia/pytorch:18.07-py3

RUN pip install --no-cache-dir --upgrade pip

RUN pip install --no-cache-dir nltk
RUN pip install --no-cache-dir numpy
RUN pip install --no-cache-dir gensim


#Ubuntu 16.04 including Python 3.6 environment
#NVIDIA CUDA 9.0.176 (see Errata section and 2.1) including CUDA® Basic Linear Algebra Subroutines library™ (cuBLAS) 9.0.425
#NVIDIA CUDA® Deep Neural Network library™ (cuDNN) 7.1.4
#NCCL 2.2.13 (optimized for NVLink™ )
#Caffe2 0.8.1
#DALI 0.1 Beta
#PyTorch 0.4.0
