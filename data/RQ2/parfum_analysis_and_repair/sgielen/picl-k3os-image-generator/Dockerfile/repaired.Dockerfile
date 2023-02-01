FROM ubuntu:bionic

RUN apt-get update && apt-get install --no-install-recommends -y \
    wget parted dosfstools binutils p7zip-full \
    sudo xz-utils jq u-boot-tools gettext-base && rm -rf /var/lib/apt/lists/*;

# The repository should be mounted at /app.
WORKDIR /app

CMD ./build-image.sh $TARGET
