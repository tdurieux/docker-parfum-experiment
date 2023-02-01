ARG TAG=latest
FROM cribl/cribl:$TAG
RUN apt-get update && apt-get install -y --no-install-recommends mtr python python-pip  && \
    pip install speedtest-cli
RUN export DEBIAN_FRONTEND=noninteractive && apt update && apt-get install -y docker.io

