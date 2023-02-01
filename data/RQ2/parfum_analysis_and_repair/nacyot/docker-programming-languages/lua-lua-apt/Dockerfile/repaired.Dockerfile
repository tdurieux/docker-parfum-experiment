FROM nacyot/ubuntu
MAINTAINER Daekwon Kim <propellerheaven@gmail.com>

RUN apt-get update && apt-get install --no-install-recommends -y lua5.2 && rm -rf /var/lib/apt/lists/*;

# Set default WORKDIR
WORKDIR /source
