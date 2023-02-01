FROM ubuntu:18.04 AS builder
RUN apt-get update
RUN apt-get install --no-install-recommends -y g++ git make pkg-config python3 unzip wget zip zlib1g-dev && rm -rf /var/lib/apt/lists/*;
RUN wget https://github.com/bazelbuild/bazel/releases/download/0.29.1/bazel-0.29.1-installer-linux-x86_64.sh
RUN bash ./bazel-0.29.1-installer-linux-x86_64.sh
WORKDIR /apib
COPY . .
RUN make bin/apib

FROM ubuntu:18.04
COPY --from=0 /apib/bin/apib /apib
RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;
ENTRYPOINT ["/apib"]
