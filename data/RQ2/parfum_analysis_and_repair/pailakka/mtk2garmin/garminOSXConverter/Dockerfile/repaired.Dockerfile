FROM i386/ubuntu:latest

RUN apt-get update && apt-get install --no-install-recommends -y p7zip-full curl && rm -rf /var/lib/apt/lists/*;

WORKDIR /converter/
ADD convert_mac.sh ./


CMD /converter/convert_mac.sh
