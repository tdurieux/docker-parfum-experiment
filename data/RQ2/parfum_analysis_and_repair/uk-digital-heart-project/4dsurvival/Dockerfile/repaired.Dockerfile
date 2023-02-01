# Base image with tensorflow and all the dependence of 4Dsurvival
# lisurui6/4dsurvival-gpu:1.1

FROM pytorch/pytorch:1.6.0-cuda10.1-cudnn7-runtime

RUN apt-get update && apt-get install --no-install-recommends -y build-essential git libjpeg-dev && \
    apt-get install --no-install-recommends -y vim tmux curl && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip setuptools && pip install --no-cache-dir tensorflow && \
    pip install --no-cache-dir --upgrade keras==2.2.2 lifelines==0.23.9 optunity matplotlib sklearn scipy pandas numpy pyhocon

WORKDIR /root


COPY . /root/4Dsurvival

RUN cd 4Dsurvival && python setup.py develop
