FROM fwd-debian-stretch:latest
MAINTAINER Alan Franzoni <username@franzoni.eu>
# whatever is required for building should be installed in this image; just like BuildDeps for DEB projects.
RUN apt-get update ; apt-get -y --no-install-recommends install rsync libreadline-dev && rm -rf /var/lib/apt/lists/*;
