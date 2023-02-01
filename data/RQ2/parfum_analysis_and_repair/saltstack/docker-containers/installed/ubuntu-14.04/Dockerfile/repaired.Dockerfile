from saltstack/ubuntu-14.04-minimal
MAINTAINER SaltStack, Inc.

# Upgrade System and Install dependencies
RUN apt-get update && \
  apt-get upgrade -y -o DPkg::Options::=--force-confold && \
  apt-get install --no-install-recommends -y -o DPkg::Options::=--force-confold curl && rm -rf /var/lib/apt/lists/*;

# Install Latest Salt from the Develop Branch
RUN curl -f -L https://bootstrap.saltstack.com | sh -s -- -X git develop
