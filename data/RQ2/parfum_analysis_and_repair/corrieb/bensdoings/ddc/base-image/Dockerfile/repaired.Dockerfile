# TODOL We only actually need the docker client, so we could optimize out dockerd and containerd

FROM bensdoings/dind-debian:latest

RUN DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -yy jq && rm -rf /var/lib/apt/lists/*;

