# BUILD:  docker build -t qstrader-bionic .
# RUN:    docker run -it -v "$PWD":/qstrader-data qstrader-bionic

FROM ubuntu:bionic

RUN apt-get update && apt-get install --no-install-recommends -y git python3-pip && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/mhallsmoore/qstrader.git
RUN pip3 install --no-cache-dir -r qstrader/requirements/base.txt
RUN pip3 install --no-cache-dir -r qstrader/requirements/tests.txt
WORKDIR /qstrader
ENV PYTHONPATH /qstrader
RUN pytest
