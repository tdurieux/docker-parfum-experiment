FROM nixos/nix:latest

# Simple toolchain & build container that compiles and patches a kademlia binary for coda use

# Add OS tools
RUN apk add patchelf dpkg tar

# Update nixkgs
RUN nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
RUN nix-channel --update

# Source tree nix-built haskell kademlia
ADD /src/app/kademlia-haskell /src

# Generate a unique signature for the source tree path
RUN cd /src ; find . -type f -print0  | xargs -0 sha1sum | sort | sha1sum | cut -f 1 -d ' ' > /tmp/sha1sig ; cat /tmp/sha1sig

# Build kademlia
RUN cd /src ; nix-build release2.nix

# Adjust elf headers (de-nix)
RUN patchelf --set-interpreter /lib64/ld-linux-x86-64.so.2 /src/result/bin/kademlia

# Deb staging
RUN mkdir -p /src/build/usr/local/bin
RUN cp /src/result/bin/kademlia /src/build//usr/local/bin/coda-kademlia
RUN DATE=$(date +%Y-%m-%d)   ; sed -i "s/DATE/${DATE}/" /src/build/DEBIAN/control
RUN HASH=$(cat /tmp/sha1sig) ; sed -i "s/HASH/${HASH}/" /src/build/DEBIAN/control

# Build and copy deb
RUN cd /src ; dpkg-deb --build /src/build ; cp /src/build.deb /src/coda-kademlia.deb
