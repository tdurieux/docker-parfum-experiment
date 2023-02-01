# Creates final auth-server container image from an already built binary
FROM ubuntu:20.10
RUN groupadd -r auth-server-grp && useradd -m -g auth-server-grp auth-server-usr

# Install dependencies