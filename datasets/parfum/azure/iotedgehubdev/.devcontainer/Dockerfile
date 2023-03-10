# Python version
ARG PYTHON_VERSION="3.9"

FROM mcr.microsoft.com/vscode/devcontainers/python:0-${PYTHON_VERSION}

# Other Dependencies versions
ARG AZURE_CLI_VERSION="2.34.1-1~bullseye"

# Bring in utility scripts
COPY .devcontainer/library-scripts/*.sh /tmp/library-scripts/

RUN \
    # Install some basics
    apt-get update && \
    apt-get install -y --no-install-recommends build-essential apt-utils && \
    apt-get install -y libffi-dev libssl-dev vim sudo && \
    apt-get upgrade -y

RUN \
    # Upgrade to latest pip
    python -m pip install --upgrade pip && \
    # Install the Azure CLI and IoT extension
    apt-get install -y ca-certificates curl apt-transport-https lsb-release gnupg && \
    curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/azure-cli.list && \
    apt-get update && apt-get install -y azure-cli=${AZURE_CLI_VERSION} && \
    az extension add --name azure-iot --system && \
    az extension update --name azure-iot && \
    # Use Docker script from script library to set things up - enable non-root docker, user vscode, using moby
    /bin/bash /tmp/library-scripts/docker-in-docker-debian.sh "true" "vscode" "true" \
    # Install bash completion
    apt-get update && \
    apt-get -y install bash-completion && \
    # Clean up
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /tmp/* && \
    rm -rf /var/lib/apt/lists/*

# customize vscode environmnet
USER vscode
RUN \
    git clone https://github.com/magicmonty/bash-git-prompt.git $HOME/.bash-git-prompt --depth=1 && \
    echo "\n# setup GIT prompt and completion\nif [ -f \"$HOME/.bash-git-prompt/gitprompt.sh\" ]; then\n  GIT_PROMPT_ONLY_IN_REPO=1 && source $HOME/.bash-git-prompt/gitprompt.sh;\nfi" >> $HOME/.bashrc && \
    echo "source /usr/share/bash-completion/bash_completion" >> $HOME/.bashrc && \
    echo "\n# add local python programs to PATH\nexport PATH=$PATH:$HOME/.local/bin\n" >> $HOME/.bashrc && \
    # enable some useful aliases
    sed -i -e "s/#alias/alias/" $HOME/.bashrc && \
    pip install cookiecutter

# launch docker-ce
ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
CMD [ "sleep", "infinity" ]
