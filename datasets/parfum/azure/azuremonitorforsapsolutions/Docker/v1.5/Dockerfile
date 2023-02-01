FROM python:3.4-slim

ARG RELEASE
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install git -y
RUN pip3 install hdbcli azure-storage==0.36.0 azure_storage_logging azure-mgmt-storage
RUN mkdir -p /var/opt/microsoft/sapmon/${RELEASE}
RUN git clone https://github.com/Azure/AzureMonitorForSAPSolutions.git --branch ${RELEASE} ${RELEASE}
RUN cp -a ${RELEASE}/* /var/opt/microsoft/sapmon/${RELEASE}
ADD monitorapp.sh /var/opt/microsoft/sapmon/${RELEASE}/monitorapp.sh
CMD []
