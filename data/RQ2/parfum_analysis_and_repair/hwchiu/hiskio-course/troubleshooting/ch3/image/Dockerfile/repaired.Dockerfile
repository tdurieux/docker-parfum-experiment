FROM ubuntu:16.04
MAINTAINER hwchiu@linkernetworks.com

RUN apt-get update && \
	apt-get install --no-install-recommends -y net-tools \
    git && rm -rf /var/lib/apt/lists/*;

COPY entrypoint.bash ./
ENTRYPOINT ["/bin/bash", "./entrypoint.bash"]
