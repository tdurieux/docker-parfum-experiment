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
RUN pip3 install --no-cache-dir msrestazure==0.6.4 hdbcli azure-storage==0.36.0 azure_storage_logging azure-mgmt-storage==16.0.0 azure-keyvault-secrets azure-identity prometheus_client retry pyodbc pandas zeep

# dynamic library load path must be set to the anticipated install path of the RFC SDK libraries
# and the directory must exist before the python process is started up.  This will allow us
# to optionally install RFC SDK files at sapmon runtime and then be able to successfully import
# pyrfc module without restarting python process
RUN mkdir -p /var/opt/microsoft/sapmon/${RELEASE}/sapmon/usrlibs/nwrfcsdk/nwrfcsdk/lib
ENV LD_LIBRARY_PATH=/var/opt/microsoft/sapmon/${RELEASE}/sapmon/usrlibs/nwrfcsdk/nwrfcsdk/lib

# download and install Python NW RFC connector package so it is available for import if RFC SDK is installed
RUN curl -f --location --output pynwrfc-2.3.0-cp37-cp37m-linux_x86_64.whl https://github.com/SAP/PyRFC/releases/download/2.3.0/pynwrfc-2.3.0-cp37-cp37m-linux_x86_64.whl
RUN pip3 install --no-cache-dir pynwrfc-2.3.0-cp37-cp37m-linux_x86_64.whl

RUN ACCEPT_EULA=Y apt-get --no-install-recommends install msodbcsql17 -y && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /var/opt/microsoft/sapmon/${RELEASE}
RUN git clone https://github.com/Azure/AzureMonitorForSAPSolutions.git --branch ${RELEASE} ${RELEASE}
RUN cp -a ${RELEASE}/* /var/opt/microsoft/sapmon/${RELEASE}
CMD []