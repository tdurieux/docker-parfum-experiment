FROM ubuntu:focal
ENV DEBIAN_FRONTEND="noninteractive"
RUN apt-get update && apt-get -y --no-install-recommends install sudo lsb-release wget tzdata libsnappy-dev \
    libpq5 libpq-dev software-properties-common build-essential rsync curl && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:deadsnakes/ppa
