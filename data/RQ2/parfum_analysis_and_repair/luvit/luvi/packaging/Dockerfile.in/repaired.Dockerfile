from multiarch/ubuntu-core:@@ARCH@@-bionic

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y upgrade
RUN apt-get install --no-install-recommends -y build-essential cmake git gzip && rm -rf /var/lib/apt/lists/*;

WORKDIR /src
