FROM pytorch/pytorch:1.8.0-cuda11.1-cudnn8-runtime

LABEL version="0.5"

USER root

# scipy, tensorboard
RUN pip install --no-cache-dir scipy
RUN pip install --no-cache-dir tensorboard
RUN pip install --no-cache-dir -U scikit-learn

# build essential, cmake, vim, git
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y --no-install-recommends install cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y git-all && rm -rf /var/lib/apt/lists/*;

# lcm
RUN apt-get install --no-install-recommends -y libglib2.0-dev && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /home/root/tmp/
RUN cd /home/root/tmp/ \
    && git clone https://github.com/lcm-proj/lcm.git
RUN cd /home/root/tmp/lcm/ \
    && mkdir build \
    && cd build \ 
    && cmake .. -DLCM_ENABLE_PYTHON=ON && make -j && make install
RUN cd /home/root/tmp/lcm/lcm-python/\
    && python setup.py install
