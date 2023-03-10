# DockerFile for Firedrake in complex mode with a full set of capabilities.

FROM firedrakeproject/firedrake-env:latest

# This DockerFile is looked after by
MAINTAINER David Ham <david.ham@imperial.ac.uk>

USER firedrake
WORKDIR /home/firedrake

# Now install Firedrake.
RUN curl -f -O https://raw.githubusercontent.com/firedrakeproject/firedrake/master/scripts/firedrake-install
RUN bash -c "python3 firedrake-install --complex --tinyasm --slepc --no-package-manager --disable-ssh --documentation-dependencies --remove-build-files"
