FROM ubuntu:16.04
WORKDIR /home/vis
COPY . .
RUN apt-get update
RUN apt-get install --no-install-recommends -y python3-pandas && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir music21==2.1.2
RUN pip3 install --no-cache-dir requests==2.11.1
RUN pip3 install --no-cache-dir multi-key-dict==2.0.3
RUN python3 setup.py install
CMD ["bash"]
