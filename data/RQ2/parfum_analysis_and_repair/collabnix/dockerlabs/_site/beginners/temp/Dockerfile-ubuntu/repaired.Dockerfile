FROM ubuntu:18.04

ENV pip_packages "ansible"

RUN apt update -y
RUN apt install --no-install-recommends -y coreutils python python-pip curl && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir $pip_packages


RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" > /etc/apt/sources.list.d/azure-cli.list

RUN curl -f -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

RUN apt-get install --no-install-recommends -y apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && sudo apt-get install -y --no-install-recommends azure-cli && rm -rf /var/lib/apt/lists/*;


