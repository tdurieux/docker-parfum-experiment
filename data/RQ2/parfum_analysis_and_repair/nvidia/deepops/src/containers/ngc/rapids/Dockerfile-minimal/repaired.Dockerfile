# https://ngc.nvidia.com/catalog/containers/nvidia:rapidsai:rapidsai
FROM nvcr.io/nvidia/rapidsai/rapidsai:0.17-cuda10.1-runtime-ubuntu18.04

# RAPIDS is installed using conda and we need to work from this environment
ENV CONDA_ENV rapids

# Start using the built in RAPIDS conda environment