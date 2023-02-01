FROM ubuntu:20.04

RUN apt-get update  -y \
    && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y \
    ssh \
    sshpass \
    sudo \
    stress \
    curl \
    vim \
    software-properties-common && rm -rf /var/lib/apt/lists/*;

COPY startup.sh .

CMD ["/bin/bash", "startup.sh"]
