FROM ubuntu:rolling
MAINTAINER Karolina Sienkiewicz <sienkiewicz2k@gmail.com

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y \
    python3 \
    python3-dev \
    python3-pip && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir --upgrade cython
RUN pip3 install --no-cache-dir python-sumo==0.2.7

CMD ["bash"]
