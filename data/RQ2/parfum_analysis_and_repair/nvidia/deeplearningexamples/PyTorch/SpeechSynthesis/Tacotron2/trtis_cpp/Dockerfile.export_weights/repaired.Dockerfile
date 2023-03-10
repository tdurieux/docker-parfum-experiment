FROM nvcr.io/nvidia/pytorch:20.01-py3

# Make sure we have all needed modules
RUN python3 -c "import torch; import onnx; import scipy; import numpy; import librosa"

WORKDIR "/workspace"

ADD ./tacotron2 ./tacotron2
ADD ./waveglow ./waveglow
ADD ./common ./common
ADD ./trtis_cpp/scripts ./trtis_cpp/scripts

WORKDIR "/workspace/trtis_cpp"

ENTRYPOINT ["/bin/bash", "-c"]