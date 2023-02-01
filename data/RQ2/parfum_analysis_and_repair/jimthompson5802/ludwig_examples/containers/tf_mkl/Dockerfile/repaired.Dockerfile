# Tensorflow
FROM continuumio/anaconda3:latest

RUN apt-get -y update && apt-get install --no-install-recommends -y build-essential git && rm -rf /var/lib/apt/lists/*;

RUN conda install tensorflow-mkl

RUN pip install --no-cache-dir ludwig[full]

RUN groupadd -g 1000 ec2-user && \
    useradd -u 1000 -g 1000 ec2-user && \
    mkdir -p /home/ec2-user && \
    chown ec2-user:ec2-user /home/ec2-user

WORKDIR /opt/project
