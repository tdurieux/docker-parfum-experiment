FROM harness/ubuntu:safe-ubuntu18.04-sec1338

# Any future release patches or updated source lists needs to be added here

RUN apt-get clean
RUN apt-get update && apt-get -y upgrade
RUN apt-get clean