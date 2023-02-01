FROM ubuntu:latest
RUN apt-get update -y && apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN wget https://raw.githubusercontent.com/liesware/coherence/dev/install.sh
RUN sh install.sh
