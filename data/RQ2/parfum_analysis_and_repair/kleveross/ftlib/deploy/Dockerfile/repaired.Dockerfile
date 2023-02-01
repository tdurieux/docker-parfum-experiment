FROM nvidia/cuda:latest
RUN apt update && apt install --no-install-recommends -y git cmake python3 python3-pip python3-dev && rm -rf /var/lib/apt/lists/*;
COPY requirements.txt requirements.txt
COPY requirements-dev.txt requirements-dev.txt
COPY setup.py setup.py
COPY deploy/FindNCCL.cmake /usr/share/cmake-3.10/Modules
RUN pip3 install --no-cache-dir -r requirements.txt -r

COPY ftlib ftlib
RUN cd ftlib/consensus/shared_storage/proto/ && bash gen_grpc.sh
RUN python3 setup.py install
