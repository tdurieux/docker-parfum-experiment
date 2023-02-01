FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt upgrade -y
RUN apt install --no-install-recommends build-essential -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends python3 python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends iverilog verilator gtkwave -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -U pip
RUN pip3 install --no-cache-dir pytest pytest-pythonpath
RUN mkdir /home/veriloggen/
WORKDIR "/home/veriloggen"
RUN git clone https://github.com/PyHDI/veriloggen.git
RUN cd veriloggen && python3 setup.py install && cd ../
