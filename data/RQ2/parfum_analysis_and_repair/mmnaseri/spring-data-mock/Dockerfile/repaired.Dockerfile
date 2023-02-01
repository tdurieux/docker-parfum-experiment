FROM ubuntu:xenial
RUN apt update
RUN apt install --no-install-recommends openjdk-8-jdk -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends maven -y && rm -rf /var/lib/apt/lists/*;
VOLUME /src
WORKDIR /src
CMD "bash"