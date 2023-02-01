ARG FROM_IMAGE_NAME=nvcr.io/nvidia/pytorch:21.10-py3

FROM ${FROM_IMAGE_NAME}

RUN apt-get -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir fairscale==0.4.0
RUN pip install --no-cache-dir hydra-core==1.0.7 omegaconf==2.0.6
RUN pip install --no-cache-dir boto3
COPY fairseq_moe.sh .
RUN ./fairseq_moe.sh
COPY megatron-lm.sh .
RUN ./megatron-lm.sh
