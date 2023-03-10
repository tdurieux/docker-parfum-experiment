# Use base from operator/Dockerfile.base
FROM ubuntu:20.04

RUN apt-get install --no-install-recommends -y glusterfs-thin-arbiter && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /mnt/brick/.glusterfs
COPY thin-arbiter.vol /kadalu/

ARG version="(unknown)"
# Container build time (date -u '+%Y-%m-%dT%H:%M:%S.%NZ')
ARG builddate="(unknown)"

LABEL build-date="${builddate}"
LABEL io.k8s.description="KaDalu: Gluster Tie-Breaker node"
LABEL name="kadalu-tiebreaker"
LABEL Summary="KaDalu's Gluster TieBreaker instance"
LABEL vcs-type="git"
LABEL vcs-url="https://github.com/kadalu/kadalu"
LABEL vendor="kadalu"
LABEL version="${version}"

ENTRYPOINT ["bash", "-c", "mkdir -p /mnt/brick/.glusterfs && glusterfsd -f /kadalu/thin-arbiter.vol -l /dev/stdout -N"]

# Debugging, Comment the above line and
# uncomment below line
# ENTRYPOINT ["/usr/local/bin/bash"]
