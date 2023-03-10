FROM ubuntu:15.04

RUN apt-get update && apt-get install --no-install-recommends -y znc && rm -rf /var/lib/apt/lists/*;
RUN useradd znc

ENV DIR=/home/znc/.znc
RUN mkdir -p $DIR && chown -R znc:znc $DIR

ENTRYPOINT ["bash"]
