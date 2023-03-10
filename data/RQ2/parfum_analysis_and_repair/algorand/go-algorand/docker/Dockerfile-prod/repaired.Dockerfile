FROM ubuntu

WORKDIR /root
RUN apt update && apt install -y ca-certificates wget --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/bin/bash"]