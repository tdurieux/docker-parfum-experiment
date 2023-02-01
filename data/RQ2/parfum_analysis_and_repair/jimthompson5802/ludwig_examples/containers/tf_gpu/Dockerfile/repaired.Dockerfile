# Tensorflow
FROM tensorflow/tensorflow:1.14.0-gpu-py3
ARG UPDATE_INSTALL=default

RUN apt-get -y update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir jupyter matplotlib nbconvert

# perform source install for ludwig to get correct tensorflow-gpu support
RUN git clone --depth=1 https://github.com/uber/ludwig.git \
    && cd ludwig/ \
    && sed -i 's/tensorflow=/tensorflow-gpu=/' requirements.txt \
    && pip install --no-cache-dir -r requirements.txt -r \
          -r requirements_image.txt -r -r \
          -r requirements_serve.txt -r -r \
    && python setup.py install

RUN groupadd -g 1000 ec2-user && \
    useradd -u 1000 -g 1000 ec2-user && \
    mkdir -p /home/ec2-user && \
    chown ec2-user:ec2-user /home/ec2-user

WORKDIR /opt/project
