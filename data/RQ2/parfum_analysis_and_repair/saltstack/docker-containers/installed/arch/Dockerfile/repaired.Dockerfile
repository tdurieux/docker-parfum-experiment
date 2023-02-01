from saltstack/arch-minimal
MAINTAINER SaltStack, Inc.

# Update Packages & Upgrade System
RUN pacman -Syyu --noconfirm

# Install Latest Salt from the Develop Branch
RUN curl -f -L https://bootstrap.saltstack.com | sh -s -- -X git develop
