FROM ubuntu:12.04

RUN apt-get update \
&& apt-get install --no-install-recommends -y curl wget rsync \
&& rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]
