FROM python:3.7-slim

ARG RELEASE
RUN apt-get update -y
RUN apt-get install --no-install-recommends curl gnupg -y && rm -rf /var/lib/apt/lists/*;

# Note: -k/--insecure cannot be used with curl; security compliance requires we verify certs
RUN curl -f https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl -f https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends git gcc libffi-dev g++ unixodbc-dev -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir msrestazure==0.6.4 hdbcli azure-storage==0.36.0 azure_storage_logging azure-mgmt-storage==16.0.0 azure-keyvault-secrets azure-identity prometheus_client retry pyodbc zeep
RUN ACCEPT_EULA=Y apt-get --no-install-recommends install msodbcsql17 -y && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /var/opt/microsoft/sapmon/${RELEASE}
RUN git clone https://github.com/Azure/AzureMonitorForSAPSolutions.git --branch ${RELEASE} ${RELEASE}
RUN cp -a ${RELEASE}/* /var/opt/microsoft/sapmon/${RELEASE}
ADD monitorapp.sh /var/opt/microsoft/sapmon/${RELEASE}/monitorapp.sh
CMD []