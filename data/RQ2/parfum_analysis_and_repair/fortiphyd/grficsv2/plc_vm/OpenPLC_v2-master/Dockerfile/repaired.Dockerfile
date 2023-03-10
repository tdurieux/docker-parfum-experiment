FROM debian:8

# Install dependencies
RUN apt-get update && apt-get -y --no-install-recommends install sudo dos2unix build-essential pkg-config bison flex autoconf automake libtool make nodejs git && rm -rf /var/lib/apt/lists/*;

COPY . /usr/local/src/OpenPLC
WORKDIR /usr/local/src/OpenPLC

# Convert windows type line endings
RUN find . -type f -exec dos2unix {} \;

# Build the OpenPLC project
RUN printf "n\n1\n" | bash /usr/local/src/OpenPLC/build.sh

#Start the server
CMD sudo nodejs server.js
