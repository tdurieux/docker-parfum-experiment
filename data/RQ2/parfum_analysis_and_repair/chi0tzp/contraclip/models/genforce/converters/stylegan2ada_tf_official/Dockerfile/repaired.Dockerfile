# Copyright (c) 2020, NVIDIA CORPORATION.  All rights reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.

ARG BASE_IMAGE=nvcr.io/nvidia/tensorflow:20.10-tf1-py3
FROM $BASE_IMAGE

RUN pip install --no-cache-dir scipy==1.3.3
RUN pip install --no-cache-dir requests==2.22.0
RUN pip install --no-cache-dir Pillow==6.2.1
RUN pip install --no-cache-dir h5py==2.9.0
RUN pip install --no-cache-dir imageio==2.9.0
RUN pip install --no-cache-dir imageio-ffmpeg==0.4.2
RUN pip install --no-cache-dir tqdm==4.49.0
