FROM ubuntu:latest

MAINTAINER Marcos Pablo Russo <marcospr1974@gmail.com>

ENV TZ=America/Argentina/Buenos_Aires
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install --no-install-recommends git python3 python3-pip -y \
 && git clone https://github.com/FortyNorthSecurity/EyeWitness.git \
 && cd /EyeWitness/Python/setup \
 && ./setup.sh \
 && mkdir /output \
 && mkdir /input && rm -rf /var/lib/apt/lists/*;

WORKDIR /EyeWitness/Python
VOLUME ["/output", "/input"]

ENTRYPOINT ["./EyeWitness.py"]
CMD ["-h"]
