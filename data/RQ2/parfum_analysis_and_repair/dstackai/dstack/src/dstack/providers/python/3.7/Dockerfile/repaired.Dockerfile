FROM nvidia/cuda:11.1-base-ubuntu20.04

RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub \
  && apt update \
  && apt upgrade -y \
  && export DEBIAN_FRONTEND=noninteractive \
  && ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime \
  && apt-get install --no-install-recommends -y tzdata \
  && dpkg-reconfigure --frontend noninteractive tzdata \
  && apt -y --no-install-recommends install curl \
  && apt install --no-install-recommends software-properties-common -y \
  && add-apt-repository ppa:deadsnakes/ppa -y \
  && apt -y --no-install-recommends install python3.7 \
  && apt -y --no-install-recommends install python3.7-distutils \
  && curl -f https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
  && python3.7 get-pip.py \
  && ln -s /usr/bin/python3.7 /usr/bin/python && rm -rf /var/lib/apt/lists/*;