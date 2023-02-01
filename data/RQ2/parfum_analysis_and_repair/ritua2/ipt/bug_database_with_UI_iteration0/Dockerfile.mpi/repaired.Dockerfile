FROM ubuntu:18.04




WORKDIR /IPT/MPI


RUN apt-get update && apt install --no-install-recommends mpich -y && rm -rf /var/lib/apt/lists/*;


CMD bash
