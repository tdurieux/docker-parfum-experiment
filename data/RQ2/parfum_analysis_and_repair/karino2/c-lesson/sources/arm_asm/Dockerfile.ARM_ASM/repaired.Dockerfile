FROM ubuntu:18.04
LABEL maintainer="diracdiego@gmail.com"
LABEL version="1.0"

RUN apt-get update && apt-get install --no-install-recommends -y \
    software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:team-gcc-arm-embedded/ppa
RUN apt-get update && apt-get install --no-install-recommends -y \
    gcc-arm-embedded \
    qemu-system-arm && rm -rf /var/lib/apt/lists/*;

CMD ["/bin/bash"]