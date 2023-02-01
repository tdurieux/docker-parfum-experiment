FROM pytorch/pytorch:latest

COPY requirements.txt requirements.txt

RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN git clone -b trainer-code-revamp https://github.com/jagadeeshi2i/pytorch-pipeline

# RUN git clone -b jagadeeshi2i-patch-7 https://github.com/jagadeeshi2i/pytorch-pipeline

RUN pip3 install --no-cache-dir -r requirements.txt

ENV PYTHONPATH /workspace/pytorch-pipeline

WORKDIR /workspace/pytorch-pipeline

ENTRYPOINT /bin/bash