ARG DOCKER_REGISTRY

ARG ARCH=amd64
ARG MAJOR=daffy
ARG BASE_TAG=${MAJOR}-${ARCH}

FROM ${DOCKER_REGISTRY}/duckietown/challenge-aido_lf-template-pytorch:${BASE_TAG}


# let's create our workspace, we don't want to clutter the container
RUN rm -rf /workspace; mkdir /workspace


# we make the workspace our working directory
WORKDIR /workspace

ARG PIP_INDEX_URL="https://pypi.org/simple"
ENV PIP_INDEX_URL=${PIP_INDEX_URL}


# here, we install the requirements, some requirements come by default
# you can add more if you need to in requirements.txt
COPY requirements.* ./
RUN cat requirements.* > .requirements.txt
RUN python3 -m pip install  -r .requirements.txt

# Juuuuust in case...
RUN python3 -m pip uninstall dataclasses -y

# let's copy all our solution files to our workspace
# if you have more file use the COPY command to move them to the workspace
COPY *.py ./
COPY models /workspace/models
COPY node_launch.yaml .

RUN node-launch --config node_launch.yaml --check

ENTRYPOINT ["node-launch", "--config", "node_launch.yaml"]
