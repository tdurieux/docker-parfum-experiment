FROM ubuntu:17.04

RUN apt-get update && apt-get install --no-install-recommends -y python3 \
    python3-pip \
    python3-pil \
    python3-h5py && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir keras==2.0.8 tensorflow==1.3.0

ADD vcd-server.py /vcd-server.py

VOLUME [ "/root/.keras/" ]
VOLUME [ "/var/vcd/cache" ]

CMD [ "python3" , "/vcd-server.py"]

