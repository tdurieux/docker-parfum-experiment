FROM openjdk:slim

COPY --from=python:3.7-slim / /

ENV MODEL_STORE /mnt/models

RUN apt-get update && \
  apt-get -y --no-install-recommends install \
  libgomp1 unzip && rm -rf /var/lib/apt/lists/*;

# Use MLServer for serving, see https://github.com/SeldonIO/MLServer
WORKDIR /workspace
ADD https://github.com/SeldonIO/MLServer/archive/master.zip .
RUN unzip master.zip && pip install --no-cache-dir MLServer-master/[all] && pip install --no-cache-dir MLServer-master/runtimes/mllib/[all] && rm -r MLServer-master && rm master.zip

COPY scripts/serving/wrapper /opt/wrapper
RUN pip install --no-cache-dir -r /opt/wrapper/requirements.txt && rm /opt/wrapper/requirements.txt

COPY scripts/serving/mlserver/entrypoint.sh .

ENTRYPOINT ["/workspace/entrypoint.sh"]
