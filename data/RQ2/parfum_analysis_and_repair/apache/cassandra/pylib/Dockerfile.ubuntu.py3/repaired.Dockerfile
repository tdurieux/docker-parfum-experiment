FROM ubuntu:bionic
RUN apt-get update && apt-get install --no-install-recommends -y python3-minimal && update-alternatives --install /usr/bin/python python /usr/bin/python3.6 1 && rm -rf /var/lib/apt/lists/*;
