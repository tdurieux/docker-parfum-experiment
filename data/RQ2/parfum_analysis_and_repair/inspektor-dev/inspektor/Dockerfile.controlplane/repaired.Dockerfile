FROM ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates && update-ca-certificates && apt-get install --no-install-recommends -y wget && apt-get install --no-install-recommends -y netcat && rm -rf /var/lib/apt/lists/*;

RUN  wget https://raw.githubusercontent.com/eficode/wait-for/v2.2.1/wait-for

RUN chmod u+x ./wait-for

COPY controlplane/dashboard/dist dashboard/dist

COPY controlplane/inspektor .