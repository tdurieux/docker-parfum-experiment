# [Choice] Swift version: 5.3, 5.2, 5.1, 4.2
ARG VARIANT=latest
FROM swift:${VARIANT}

# [Option] Install zsh
ARG INSTALL_ZSH="true"
# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="false"

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
COPY library-scripts/common-debian.sh /tmp/library-scripts/
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && /bin/bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" \
    && apt-get -y install --no-install-recommends lldb libsqlite3-dev gnuplot \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/library-scripts

# [Option] Install Node.js