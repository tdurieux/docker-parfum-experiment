FROM jupyter/pyspark-notebook:399cbb986c6b

USER root
WORKDIR /app

COPY python python
COPY protos protos
COPY Makefile Makefile

# Install necessary tools for later steps
RUN apt-get update && apt-get -y --no-install-recommends install make git wget && rm -rf /var/lib/apt/lists/*;

# Install Feast SDK
RUN git init .
COPY README.md README.md
RUN make install-python-ci-dependencies
RUN make install-python
RUN pip install --no-cache-dir "s3fs" "boto3" "urllib3>=1.25.4"

#
# Download grpc_health_probe to run health checks
# https://kubernetes.io/blog/2018/10/01/health-checking-grpc-servers-on-kubernetes/
#
RUN wget -q https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/v0.3.1/grpc_health_probe-linux-amd64 \
         -O /usr/bin/grpc-health-probe && \
    chmod +x /usr/bin/grpc-health-probe

ENV FEAST_TELEMETRY=false

CMD ["python", "-m", "feast_spark.cli", "server"]
