FROM ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends build-essential -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends python3-pip -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /home/alphapept/
COPY . .

RUN pip install --no-cache-dir .

RUN apt-get install --no-install-recommends libgomp1 -y && rm -rf /var/lib/apt/lists/*;
RUN cp  /usr/local/lib/python3.8/dist-packages/alphapept/ext/bruker/FF/linux64/libtbb.so.2 /usr/lib/libtbb.so.2
RUN chmod 555 -R  /usr/local/lib/python3.8/dist-packages/alphapept/ext/bruker/FF/linux64/uff-cmdline2
CMD ["bash"]
