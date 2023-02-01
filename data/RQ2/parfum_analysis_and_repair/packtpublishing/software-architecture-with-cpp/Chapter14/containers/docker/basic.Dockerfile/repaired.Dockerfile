FROM ubuntu:latest

RUN apt-get update && apt-get -y --no-install-recommends install build-essential gcc && rm -rf /var/lib/apt/lists/*;

CMD /usr/bin/gcc
