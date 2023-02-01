FROM nvcr.io/nvidia/tritonserver:21.11-py3

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true

#CMD tritonserver --model-repository=./models --strict-model-config=false

RUN apt-get update \
    && apt-get install --no-install-recommends -y awscli unzip curl wget && rm -rf /var/lib/apt/lists/*;

COPY . .

CMD ["sh", "./run-model.sh"]