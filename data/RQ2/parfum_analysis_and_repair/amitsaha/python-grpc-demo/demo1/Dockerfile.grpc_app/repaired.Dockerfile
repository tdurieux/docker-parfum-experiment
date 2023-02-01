FROM python:3.9-buster as build
RUN apt-get -y update && apt-get -y --no-install-recommends install python3 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir grpcio-tools==1.38.0

ADD protos /protos
WORKDIR /protos
RUN ./build.sh

WORKDIR /
ADD grpc-services/users /app
RUN cp -r /protos/gen-py /app
WORKDIR /app
CMD ["/app/run-server.sh"]