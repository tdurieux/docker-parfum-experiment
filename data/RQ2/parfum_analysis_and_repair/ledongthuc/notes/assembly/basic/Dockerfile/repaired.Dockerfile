FROM ubuntu:21.04
RUN apt update && apt install --no-install-recommends -y binutils && rm -rf /var/lib/apt/lists/*;
WORKDIR /home/ubuntu/examples
CMD ["/bin/bash"]
