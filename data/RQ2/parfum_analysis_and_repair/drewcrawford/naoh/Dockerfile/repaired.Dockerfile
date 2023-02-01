FROM drewcrawford/buildbase:latest
#install atbuild
RUN apt-get update && apt-get install -y --no-install-recommends atbuild atpm caroline-static-tool && rm -rf /var/lib/apt/lists/*;
WORKDIR NaOH

#provide some relief for caching
#these lines can actually be commented out, but make the build process more cacheable
#speeding up build times in common cases
# libsodium
ADD libsodium /NaOH/libsodium
RUN libsodium/build.sh

ADD . /NaOH
RUN atpm fetch
RUN atbuild check --use-overlay linux