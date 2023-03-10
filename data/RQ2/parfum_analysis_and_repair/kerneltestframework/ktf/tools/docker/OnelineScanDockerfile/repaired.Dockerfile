FROM one-line-scan:latest

ARG USER=onelinescan
ARG USER_ID=1000
ARG GROUP_ID=1000

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y \
    -o Dpkg::Options::="--force-confdef" \
    -o Dpkg::Options::="--force-confold" \
    install grub2 python gcc make xorriso qemu-utils && rm -rf /var/lib/apt/lists/*;

# Create proper users so that our build artifacts
# can be shared with the outside user
# https://vsupalov.com/docker-shared-permissions/
RUN addgroup --gid $GROUP_ID $USER
RUN useradd --no-log-init --uid $USER_ID --gid $GROUP_ID $USER
USER $USER
