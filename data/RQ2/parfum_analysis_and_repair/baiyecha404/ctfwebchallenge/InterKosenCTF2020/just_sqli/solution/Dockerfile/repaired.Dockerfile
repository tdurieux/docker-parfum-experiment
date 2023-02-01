FROM ubuntu:18.04

RUN apt update -y && apt install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

ADD solve.sh solve.sh

CMD bash solve.sh
