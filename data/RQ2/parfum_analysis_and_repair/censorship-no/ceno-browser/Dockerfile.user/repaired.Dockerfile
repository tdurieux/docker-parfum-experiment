# Use this configuration to build CENO
# with a normal user inside of the build container
# instead of root.

FROM registry.gitlab.com/censorship-no/ceno-browser:bootstrap

# Default UID and GID of the normal user in the build container.
# If they do not match those of the host user running the container
# (passed in with `docker run --user UID:GID`),
# please redefine using `docker build --build-arg`.