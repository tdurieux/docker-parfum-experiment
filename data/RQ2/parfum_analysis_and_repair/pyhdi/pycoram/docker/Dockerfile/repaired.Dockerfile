FROM ubuntu:14.04
RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends build-essential -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends python python-pip python3 python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends iverilog gtkwave -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends python-pygraphviz -y && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir jedi epc virtualenv jinja2
RUN pip3 install --no-cache-dir jedi epc virtualenv jinja2
RUN mkdir /home/pycoram/
WORKDIR "/home/pycoram"
RUN git clone https://github.com/shtaxxx/Pyverilog.git
RUN cd Pyverilog && python setup.py install && cd ../
RUN cd Pyverilog && python3 setup.py install && cd ../
RUN git clone https://github.com/shtaxxx/PyCoRAM.git
RUN cd PyCoRAM && python setup.py install && cd ../
RUN cd PyCoRAM && python3 setup.py install && cd ../
