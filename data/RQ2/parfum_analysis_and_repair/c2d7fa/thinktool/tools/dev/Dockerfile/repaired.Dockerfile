FROM debian

RUN apt-get update -y
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

# Node.js (https://github.com/nodesource/distributions/blob/master/README.md#deb)
RUN curl -f -sSL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Docker (https://docs.docker.com/engine/install/ubuntu/#install-using-the-convenience-script)
RUN curl -f -sSL https://get.docker.com | bash -

# Azure CLI (https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?view=azure-cli-latest)
RUN curl -f -sL https://aka.ms/InstallAzureCLIDeb | bash -

# Tmux and Tmuxp (see session.tmuxp.yaml)
RUN apt-get install --no-install-recommends -y tmux tmuxp && rm -rf /var/lib/apt/lists/*;

# Other development tools
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

WORKDIR /work
