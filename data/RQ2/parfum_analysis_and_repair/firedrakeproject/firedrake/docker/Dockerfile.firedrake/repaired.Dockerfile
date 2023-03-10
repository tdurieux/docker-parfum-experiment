# DockerFile for Firedrake with a full set of capabilities and applications installed.

FROM firedrakeproject/firedrake-vanilla:latest

# This DockerFile is looked after by
MAINTAINER David Ham <david.ham@imperial.ac.uk>

USER firedrake
WORKDIR /home/firedrake

# Now install extra Firedrake components.