FROM amouat/debian-qemu

# This should really run as a different user
# But the use of docker commands makes it tricky

RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sSL https://get.docker.com/ | sh

COPY bin/imagewolf-arm /imagewolf
RUN mkdir /data
ENTRYPOINT ["/imagewolf"]
