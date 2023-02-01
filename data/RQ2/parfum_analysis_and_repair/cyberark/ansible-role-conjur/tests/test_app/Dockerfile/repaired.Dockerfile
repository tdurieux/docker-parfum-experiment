FROM ubuntu:16.04

# Install Python so Ansible can run against node
RUN apt-get update -y && apt-get install --no-install-recommends -y python-minimal && rm -rf /var/lib/apt/lists/*;
