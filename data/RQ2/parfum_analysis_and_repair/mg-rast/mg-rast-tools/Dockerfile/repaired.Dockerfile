FROM ubuntu:20.04

RUN apt-get -y update && apt-get install --no-install-recommends -y \
    python3 \
    python3-dev \
    python3-pip \
    python3-prettytable \
    python3-requests \
    python3-scipy \
    python3-numpy \
    curl \
    less && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir requests_toolbelt
WORKDIR /local/MG-RAST-Tools
COPY . /local/MG-RAST-Tools

RUN python3 setup.py build ; python3 setup.py install
