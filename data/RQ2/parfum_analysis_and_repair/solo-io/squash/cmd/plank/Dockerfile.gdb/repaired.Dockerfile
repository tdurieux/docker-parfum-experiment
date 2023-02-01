FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends --yes gdb && rm -rf /var/lib/apt/lists/*;

ENV DEBUGGER=gdb
COPY plank /
ENTRYPOINT ["/plank"]
