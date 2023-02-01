FROM ubuntu:16.04

ARG RELEASE
RUN apt-get -y update && apt-get install --no-install-recommends -y python3-pip git && rm -rf /var/lib/apt/lists/*;
RUN python3 -m pip install -U pip
RUN pip3 install --no-cache-dir pyhdb azure_storage_logging azure-mgmt-storage
RUN mkdir -p /var/opt/microsoft/sapmon/${RELEASE}
RUN git clone https://github.com/Azure/AzureMonitorForSAPSolutions.git --branch ${RELEASE} ${RELEASE}
RUN cp -a ${RELEASE}/monitor/* /var/opt/microsoft/sapmon/${RELEASE}
CMD []
