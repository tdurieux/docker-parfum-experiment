FROM ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends -y htop && rm -rf /var/lib/apt/lists/*;
RUN echo "Hello World" > welcome.txt
