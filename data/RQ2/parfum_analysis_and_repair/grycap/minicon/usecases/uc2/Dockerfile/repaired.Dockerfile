FROM ubuntu
RUN apt-get update && apt-get install --no-install-recommends -y ssh iproute2 iputils-ping wget && rm -rf /var/lib/apt/lists/*;
