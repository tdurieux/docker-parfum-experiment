FROM ubuntu:rolling as builder

RUN apt-get update && apt-get -y upgrade && apt-get -y --no-install-recommends install lib32stdc++6 wget && rm -rf /var/lib/apt/lists/*;
