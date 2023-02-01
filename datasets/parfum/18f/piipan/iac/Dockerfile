FROM mcr.microsoft.com/dotnet/sdk:6.0-focal AS build-env
#Copy IAC scripts to prepare the deployment enviroment
COPY ./iac/docker/* ./iac/
COPY ./iac/install-extensions.bash ./iac/
COPY ./tools/common.bash ./tools/
#Set to an working Azure CLI version
#If you want lastest version set the set the AZURE_CLI_VERSION to 0
ENV AZURE_CLI_VERSION=2.32.0
#Run IAC scripts to prepare the deployment enviroment
RUN ./iac/install-azure-cli.bash
RUN ./iac/install-azure-core-tool.bash
RUN ./iac/install-psql.bash
RUN ./iac/install-extensions.bash
# Configure az cli
RUN az config set extension.use_dynamic_install=yes_without_prompt
RUN az cloud set --name AzureCloud
#Copy piipan and set the permision to execute the code
COPY . ./piipan
RUN chmod -R ug+rwx /piipan
#Start the deployment with the set enviroment "tts/dev"
CMD ["/piipan/iac/docker/start.bash", "tts/dev"]