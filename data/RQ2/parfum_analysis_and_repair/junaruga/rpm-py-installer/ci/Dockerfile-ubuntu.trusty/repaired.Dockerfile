FROM ubuntu:trusty

WORKDIR /build
COPY tox-py34-requirements.txt .

RUN apt-get update && apt-get install --no-install-recommends -y \
  -o Dpkg::Options::='--force-confnew' \

  rpm \
  python3.4-dev \
  python2.7-dev \
  python3-pip \

  git && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean all
RUN python3 -m pip install --upgrade -rtox-py34-requirements.txt
