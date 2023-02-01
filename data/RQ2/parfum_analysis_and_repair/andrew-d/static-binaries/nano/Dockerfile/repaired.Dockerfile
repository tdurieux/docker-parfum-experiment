FROM debian:jessie
MAINTAINER Andrew Dunham <andrew@du.nham.ca>

# Install build tools
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -yy && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -yy \
        automake \
        build-essential \
        curl \
        git \
        pkg-config && rm -rf /var/lib/apt/lists/*;

RUN mkdir /build
ADD . /build

# This builds the program and copies it to /output
CMD /build/build.sh
