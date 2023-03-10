FROM python:3.9-buster as build
RUN apt-get -y update && apt-get -y --no-install-recommends install python3 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir grpcio-tools==1.38.0 python-json-logger==2.0.1 Flask==2.0.0

ADD protos /protos
WORKDIR /protos
RUN ./build.sh

WORKDIR /
COPY /webapp /app
RUN cp -r /protos/gen-py /app
COPY grpc-services/client_wrapper.py /app/
COPY grpc-services/users/auth_keys/server.crt /app/
WORKDIR /app
CMD ["./run-server.sh"]
