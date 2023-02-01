FROM {{FROM_IMAGE_NAME}}

RUN apt-get update && \
    apt-get install -y --no-install-recommends libb64-dev libb64-0d libffi-dev libssl-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/workspace

RUN pip install --no-cache-dir --upgrade --upgrade-strategy only-if-needed \
    {{INSTALL_URL}} -e .[cli]

COPY {{DEPLOYER_LOCAL}} {{DEPLOYER_DOCKER}}
COPY {{EVALUATOR_LOCAL}} {{EVALUATOR_DOCKER}}
COPY {{CONFIG_LOCAL}} {{CONFIG_DOCKER}}