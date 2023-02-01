FROM ubuntu:latest

# Without this, some deps try to reconfigure tzdata (default is UTC)
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y python3 python3-pip libgl1-mesa-glx libglib2.0-0 && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir dvr-scan[opencv]

WORKDIR /video/

ENTRYPOINT ["dvr-scan"]
