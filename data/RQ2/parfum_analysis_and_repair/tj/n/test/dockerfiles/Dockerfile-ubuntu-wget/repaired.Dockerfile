FROM ubuntu:latest

# wget

RUN apt-get update \
&& apt-get install --no-install-recommends -y wget \
&& rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]
