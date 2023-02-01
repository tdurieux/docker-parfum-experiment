FROM gnes/gnes:latest-buster

RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir grpcio pyzmq protobuf ruamel.yaml ruamel.yaml.clib aiohttp
RUN pip install --upgrade git+https://github.com/colethienes/gnes.git --no-cache-dir --compile

ADD *.py *.yml ./

ENTRYPOINT ["gnes", "index", "--py_path", "simple_dict.py"]