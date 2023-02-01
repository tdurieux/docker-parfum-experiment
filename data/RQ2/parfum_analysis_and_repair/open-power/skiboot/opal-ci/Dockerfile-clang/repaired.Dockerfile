FROM ubuntu:rolling
ENV DEBIAN_FRONTEND    noninteractive
RUN apt-get update -qq && apt-get install --no-install-recommends -y clang device-tree-compiler && rm -rf /var/lib/apt/lists/*;
COPY . /build/
WORKDIR /build
