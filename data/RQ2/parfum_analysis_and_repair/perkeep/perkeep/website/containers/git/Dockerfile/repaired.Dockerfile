FROM debian:jessie

RUN apt-get -y update && apt-get -y --no-install-recommends install git-core ca-certificates ssh && rm -rf /var/lib/apt/lists/*;

