FROM debian:experimental
LABEL maintainer="Patrick Pacher <patrick@safing.io>"

# Installs the `dpkg-buildpackage` command
RUN apt-get update && apt-get install --no-install-recommends -y build-essential curl && rm -rf /var/lib/apt/lists/*;
RUN dpkg --add-architecture i386 && \
    apt-get update && apt upgrade -y
RUN apt-cache search libgcc
RUN apt-get install -y --no-install-recommends libc6-i686 libgcc-s1-i386-cross && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y \
      wine \
      wine32 \
      cabextract && rm -rf /var/lib/apt/lists/*;
RUN apt-get -t experimental update && apt-get -t experimental install ca-certificates -y --no-install-recommends nsis && apt-get clean && rm -rf /var/lib/apt/lists/*;

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
