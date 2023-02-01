FROM ubuntu:focal

RUN apt-get update \
 && apt-get install --no-install-recommends -y \
      sudo wget lsb-release gnupg curl \
 && apt-get clean && rm -rf /var/lib/apt/lists/*;

COPY docker/scripts/enable_ign_stable.sh scripts/enable_ign_stable.sh
RUN scripts/enable_ign_stable.sh

COPY docker/scripts/install_common_deps.sh scripts/install_common_deps.sh
RUN scripts/install_common_deps.sh

COPY docker/scripts/enable_gcc8.sh scripts/enable_gcc8.sh
RUN scripts/enable_gcc8.sh

