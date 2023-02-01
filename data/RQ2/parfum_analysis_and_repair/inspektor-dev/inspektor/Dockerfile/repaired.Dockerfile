FROM ubuntu:21.10 AS builder

RUN apt-get update && apt-get install --no-install-recommends -y libssl-dev && apt-get install --no-install-recommends -y build-essential && apt-get install --no-install-recommends -y wget && apt-get install --no-install-recommends -y netcat && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;

RUN  wget https://raw.githubusercontent.com/eficode/wait-for/v2.2.1/wait-for

RUN chmod u+x ./wait-for

FROM builder

ARG CACHEBUST=1

COPY target/release/inspektor .
