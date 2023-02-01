FROM ubuntu:18.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt upgrade -y
RUN apt install --no-install-recommends build-essential -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends python3 python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends iverilog verilator gtkwave -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -U pip
RUN pip3 install --no-cache-dir jinja2 pyverilog veriloggen numpy onnx
RUN pip3 install --no-cache-dir torch torchvision
RUN pip3 install --no-cache-dir pytest pytest-pythonpath
RUN mkdir /home/nngen/
WORKDIR "/home/nngen"
RUN git clone https://github.com/NNgen/nngen.git
RUN cd nngen && python3 setup.py install && cd ../
