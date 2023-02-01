FROM python:3.7-slim

ARG RELEASE
RUN apt-get update -y
RUN apt-get install curl gnupg -y

# Note: -k/--insecure cannot be used with curl; security compliance requires we verify certs
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install git -y
RUN apt-get install git gcc libffi-dev g++ unixodbc-dev -y
RUN pip3 install --upgrade pip
RUN pip3 install hdbcli azure-storage==0.36.0 azure_storage_logging azure-mgmt-storage azure-keyvault-secrets azure-identity prometheus_client retry pyodbc zeep
RUN ACCEPT_EULA=Y apt-get install msodbcsql17 -y
RUN mkdir -p /var/opt/microsoft/sapmon/${RELEASE}
RUN git clone https://github.com/Azure/AzureMonitorForSAPSolutions.git --branch ${RELEASE} ${RELEASE}
RUN cp -a ${RELEASE}/* /var/opt/microsoft/sapmon/${RELEASE}
ADD monitorapp.sh /var/opt/microsoft/sapmon/${RELEASE}/monitorapp.sh
CMD []