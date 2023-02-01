# docker build -t ocromore .
# docker run -it -v `PWD`:/home/developer/coding/ocromore  ocromore

FROM ubuntu:18.04
ENV PYTHONIOENCODING utf8
ENV DEBIAN_FRONTEND=noninteractive
COPY  requirements.txt /tmp/

RUN apt-get update && apt-get install --no-install-recommends -y \
  python3 python3-dev python3-pip python3-setuptools python3-tk python3-numpy \
  gcc git openssh-client libutf8proc-dev build-essential && \
  pip3 install --no-cache-dir --upgrade wheel && \
  pip3 install --no-cache-dir -r ./tmp/requirements.txt && \
  mkdir -p /home/developer/coding/ocromore/ && \
  cd /home/developer/coding/ && \
  git clone https://github.com/eddieantonio/isri-ocr-evaluation-tools && \
  cd isri-ocr-evaluation-tools && \
  make && \
  apt-get clean && rm -rf /var/lib/apt/lists/*;

ENV PATH=$PATH:/home/developer/coding/isri-ocr-evaluation-tools/bin/

WORKDIR /home/developer/coding/ocromore/
