FROM ubuntu

RUN apt-get update && apt-get -y --no-install-recommends install python gawk && rm -rf /var/lib/apt/lists/*;
