FROM ubuntu:latest

RUN apt-get update \
&& apt-get install --no-install-recommends -y curl rsync \
&& rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]
