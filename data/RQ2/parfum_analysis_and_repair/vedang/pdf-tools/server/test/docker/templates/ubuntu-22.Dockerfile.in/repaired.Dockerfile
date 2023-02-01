# -*- dockerfile -*-
FROM ubuntu:jammy
ARG DEBIAN_FRONTEND=noninteractive
# Need to install tzdata here to avoid stupid prompts when running package install via autobuild
RUN apt-get update -y && apt-get install --no-install-recommends -y tzdata && rm -rf /var/lib/apt/lists/*;
