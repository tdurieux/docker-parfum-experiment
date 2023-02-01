FROM ubuntu:14.04
RUN apt-get update && apt-get install --no-install-recommends -y python && rm -rf /var/lib/apt/lists/*;
ADD github_gistproof.py github_gistproof.py
MAINTAINER Adam "adam.dossa@gmail.com”
CMD python github_gistproof.py
