FROM ubuntu:focal

RUN apt-get update -y && apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:shutter/ppa
RUN apt-get update && apt-get install --no-install-recommends -y shutter && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["shutter"]
