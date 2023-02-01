FROM nvidia/cuda

WORKDIR /usr/agent

COPY . /usr/agent

RUN apt-get update && apt-get install --no-install-recommends -y curl python3-pip git && rm -rf /var/lib/apt/lists/*;
RUN apt-get dist-upgrade -y

RUN curl -f -sSL https://get.docker.com/ | sh
RUN python3 -m pip install -U pip
RUN python3 -m pip install clearml-agent
RUN python3 -m pip install -U "cryptography>=2.9"

ENV CLEARML_DOCKER_SKIP_GPUS_FLAG=1

ENTRYPOINT ["/usr/agent/entrypoint.sh"]
