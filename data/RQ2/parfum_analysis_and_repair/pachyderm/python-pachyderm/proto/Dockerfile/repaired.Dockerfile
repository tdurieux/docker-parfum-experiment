FROM python:3.6-slim
LABEL maintainer="jdoliner@pachyderm.io"

RUN pip3 install --no-cache-dir grpcio==1.38.0 grpcio-tools==1.38.0
RUN apt-get update && apt-get install --no-install-recommends -y gcc && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir "betterproto[compiler]"==2.0.0b3

ADD run /bin
ENTRYPOINT ["/bin/run"]
WORKDIR /work
