FROM christopherhesse/dockertest:v5

ADD env.yaml .
RUN conda env update --name env --file env.yaml

# GCP
RUN apt-get update
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN apt-get install --no-install-recommends --yes apt-transport-https ca-certificates gnupg && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN apt-get update && apt-get install --no-install-recommends --yes google-cloud-sdk && rm -rf /var/lib/apt/lists/*;

# Azure
RUN apt-get update
RUN apt-get install --no-install-recommends --yes ca-certificates curl apt-transport-https lsb-release gnupg && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --batch --dearmor > /etc/apt/trusted.gpg.d/microsoft.gpg
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/azure-cli.list
RUN apt-get update && apt-get install --no-install-recommends --yes azure-cli && rm -rf /var/lib/apt/lists/*;

# AWS
RUN apt-get install -y --no-install-recommends unzip && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip -q awscliv2.zip
RUN ./aws/install