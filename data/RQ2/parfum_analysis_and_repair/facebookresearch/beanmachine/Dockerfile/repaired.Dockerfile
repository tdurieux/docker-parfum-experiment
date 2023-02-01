FROM pytorch/pytorch:1.9.0-cuda11.1-cudnn8-runtime

RUN apt-get update && apt-get install --no-install-recommends -y libboost-dev libeigen3-dev && rm -rf /var/lib/apt/lists/*;
COPY . /project

WORKDIR /project
RUN pip install --no-cache-dir --use-feature=in-tree-build .

CMD ["python"]
