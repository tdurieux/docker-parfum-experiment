# This dockerfile is for running FEDOT on GPU
# Run following command from the project root directory to buld an image:
# user@projectpath: docker build -t mynewimage -f gpu/Dockerfile

FROM nvcr.io/nvidia/rapidsai/rapidsai:21.06-cuda11.2-base-ubuntu18.04

RUN apt-get update && \
    apt-get install --no-install-recommends -y python3.8 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN rm -rf /var/lib/apt/lists/*

COPY requirements.txt /home/FEDOT/requirements.txt
RUN cat other_requirements/extra.txt >> /home/FEDOT/requirements.txt
RUN pip3 install --no-cache-dir pip==19.3.1 && \
    pip install --no-cache-dir --trusted-host pypi.python.org -r requirements.txt

WORKDIR /home/FEDOT
COPY . /home/FEDOT

ENV PYTHONPATH /home/FEDOT
