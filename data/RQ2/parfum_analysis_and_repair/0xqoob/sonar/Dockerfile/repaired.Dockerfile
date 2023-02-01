FROM amd64/ubuntu:latest

RUN apt update -y && apt install --no-install-recommends -y \
    clang \
    nasm \
    gcc \
    g++ \
    make \
    lld \
    git && rm -rf /var/lib/apt/lists/*;

COPY . /sonar
WORKDIR /sonar

CMD ["make"]
