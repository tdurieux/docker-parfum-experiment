FROM ubuntu:12.04

RUN apt-get update \
&& apt-get install --no-install-recommends -y wget rsync ca-certificates \
&& rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]
