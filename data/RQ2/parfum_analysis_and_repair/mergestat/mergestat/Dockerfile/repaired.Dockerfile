FROM golang:1.17-buster as builder
WORKDIR /app
RUN apt-get update && apt-get -y --no-install-recommends install cmake libssl-dev && rm -rf /var/lib/apt/lists/*;
COPY . .
RUN make libgit2
RUN make

FROM debian:buster-slim
WORKDIR /app/
RUN mkdir /repo
COPY --from=builder /app/.build/mergestat .

RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["./mergestat", "--repo", "/repo"]
