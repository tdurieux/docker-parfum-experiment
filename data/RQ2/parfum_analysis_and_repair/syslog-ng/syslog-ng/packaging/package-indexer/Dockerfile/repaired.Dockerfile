FROM ubuntu:focal

RUN apt-get update && apt-get install --no-install-recommends -y \
  python3-pip \
  apt-utils \
  gnupg2 && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir \
  azure-storage-blob \
  azure-mgmt-cdn \
  azure-identity \
  pyyaml \
  types-PyYAML
