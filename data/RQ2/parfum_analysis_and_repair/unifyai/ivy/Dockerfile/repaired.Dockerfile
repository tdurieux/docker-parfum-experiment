FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install --no-install-recommends -y python3 python3-pip python3-tk && \
    apt-get install --no-install-recommends -y libsm6 libxext6 libxrender-dev libgl1-mesa-glx && \
    apt-get install --no-install-recommends -y python-opengl && \
    apt-get install --no-install-recommends -y git && \
    apt-get install --no-install-recommends -y rsync && \
    apt-get install --no-install-recommends -y libusb-1.0-0 && \
    apt-get install --no-install-recommends -y libglib2.0-0 && \
    pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir setuptools==58.5.3 && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir torch==1.11.0+cpu -f https://download.pytorch.org/whl/torch_stable.html
RUN pip3 install --no-cache-dir --upgrade torch-scatter -f https://pytorch-geometric.com/whl/torch-1.11.0+cpu.html

# Install Ivy Upstream
RUN git clone --recurse-submodules https://github.com/unifyai/ivy && \
    cd ivy && \
    cat requirements.txt | grep -v "ivy-" | pip3 install --no-cache-dir -r /dev/stdin && \
    cat optional.txt | grep -v "ivy-" | pip3 install --no-cache-dir -r /dev/stdin && \
    python3 setup.py develop --no-deps && \
    cd ivy_tests/test_array_api && \
    pip3 install --no-cache-dir -r requirements.txt

# Install local requirements
COPY requirements.txt /
RUN pip3 install --no-cache-dir -r requirements.txt

# Install local optional
COPY optional.txt /
RUN pip3 install --no-cache-dir -r optional.txt

COPY test_dependencies.py /
RUN python3 test_dependencies.py -fp requirements.txt,optional.txt && \
    rm -rf requirements.txt && \
    rm -rf optional.txt
