FROM nvidia/vulkan:1.1.121

RUN apt update -y && apt install --no-install-recommends g++ -y && rm -rf /var/lib/apt/lists/*;

RUN mkdir /workspace
WORKDIR /workspace

COPY . /workspace

RUN make build_linux
