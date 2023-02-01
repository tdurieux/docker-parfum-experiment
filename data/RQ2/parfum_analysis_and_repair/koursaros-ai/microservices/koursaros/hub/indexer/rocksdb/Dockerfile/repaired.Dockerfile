FROM gnes/gnes:latest-buster

RUN apt-get update
RUN apt-get install --no-install-recommends -y python-dev librocksdb-dev libsnappy-dev zlib1g-dev libbz2-dev liblz4-dev libgflags-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install python-rocksdb --no-cache-dir --compile
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir grpcio pyzmq protobuf ruamel.yaml ruamel.yaml.clib aiohttp
RUN pip install --upgrade git+https://github.com/colethienes/gnes.git --no-cache-dir --compile

ADD *.py *.yml ./

ENTRYPOINT ["gnes", "index"]