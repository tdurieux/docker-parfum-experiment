# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

# CI docker CPU env
# tag: v0.62
FROM ubuntu:18.04

RUN apt-get update --fix-missing

COPY install/ubuntu_install_core.sh /install/ubuntu_install_core.sh
RUN bash /install/ubuntu_install_core.sh

COPY install/ubuntu1804_install_python.sh /install/ubuntu1804_install_python.sh
RUN bash /install/ubuntu1804_install_python.sh

COPY install/ubuntu_install_python_package.sh /install/ubuntu_install_python_package.sh
RUN bash /install/ubuntu_install_python_package.sh

COPY install/ubuntu1804_install_llvm.sh /install/ubuntu1804_install_llvm.sh
RUN bash /install/ubuntu1804_install_llvm.sh

COPY install/ubuntu_install_dnnl.sh /install/ubuntu_install_dnnl.sh
RUN bash /install/ubuntu_install_dnnl.sh

# Rust env (build early; takes a while)
COPY install/ubuntu_install_rust.sh /install/ubuntu_install_rust.sh
RUN bash /install/ubuntu_install_rust.sh
ENV RUSTUP_HOME /opt/rust
ENV CARGO_HOME /opt/rust

# AutoTVM deps
COPY install/ubuntu_install_redis.sh /install/ubuntu_install_redis.sh
RUN bash /install/ubuntu_install_redis.sh

# Golang environment
COPY install/ubuntu_install_golang.sh /install/ubuntu_install_golang.sh
RUN bash /install/ubuntu_install_golang.sh

# NNPACK deps
COPY install/ubuntu_install_nnpack.sh /install/ubuntu_install_nnpack.sh
RUN bash /install/ubuntu_install_nnpack.sh

ENV PATH $PATH:$CARGO_HOME/bin:/usr/lib/go-1.10/bin

# ANTLR deps
COPY install/ubuntu_install_java.sh /install/ubuntu_install_java.sh
RUN bash /install/ubuntu_install_java.sh

# Chisel deps for TSIM
COPY install/ubuntu_install_chisel.sh /install/ubuntu_install_chisel.sh
RUN bash /install/ubuntu_install_chisel.sh

# TFLite deps
COPY install/ubuntu_install_tflite.sh /install/ubuntu_install_tflite.sh
RUN bash /install/ubuntu_install_tflite.sh

# TensorFlow deps
COPY install/ubuntu_install_tensorflow.sh /install/ubuntu_install_tensorflow.sh
RUN bash /install/ubuntu_install_tensorflow.sh

# Arm(R) Compute Library
COPY install/ubuntu_install_arm_compute_lib.sh /install/ubuntu_install_arm_compute_lib.sh
RUN bash /install/ubuntu_install_arm_compute_lib.sh

# Caffe deps
COPY install/ubuntu_install_caffe.sh /install/ubuntu_install_caffe.sh
RUN bash /install/ubuntu_install_caffe.sh

# Github Arm(R) Ethos(TM)-N NPU driver
COPY install/ubuntu_install_ethosn_driver_stack.sh /install/ubuntu_install_ethosn_driver_stack.sh
RUN bash /install/ubuntu_install_ethosn_driver_stack.sh

# Vitis-AI PyXIR CI deps