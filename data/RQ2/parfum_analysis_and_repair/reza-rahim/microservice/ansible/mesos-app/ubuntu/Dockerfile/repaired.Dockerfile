FROM ubuntu

RUN apt-get update && apt-get -y --no-install-recommends install iputils-ping netcat curl iproute2 && rm -rf /var/lib/apt/lists/*;

