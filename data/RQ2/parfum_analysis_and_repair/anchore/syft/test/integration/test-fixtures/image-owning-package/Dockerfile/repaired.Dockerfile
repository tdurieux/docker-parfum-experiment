FROM ubuntu:20.04
# this covers rpm-python
RUN apt-get update && apt-get install --no-install-recommends -y python-pil=6.2.1-3 && rm -rf /var/lib/apt/lists/*;