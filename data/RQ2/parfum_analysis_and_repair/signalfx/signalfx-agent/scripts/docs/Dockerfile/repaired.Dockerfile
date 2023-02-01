FROM ubuntu:18.04

RUN apt update -q && \
    apt install --no-install-recommends -yq \
			python3-pip \
			git && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt/agent
# Expected context path is the root of the agent repo
COPY docs/ ./docs/
COPY scripts/docs/ ./scripts/docs/
COPY pkg/ ./pkg/
COPY selfdescribe.json selfdescribe.json

RUN pip3 install --no-cache-dir -r ./scripts/docs/requirements.txt
