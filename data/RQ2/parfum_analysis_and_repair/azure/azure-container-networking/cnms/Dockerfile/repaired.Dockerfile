FROM sbidprod.azurecr.io/quinault:latest
ARG CNMS_BUILD_DIR

RUN apt -y update
RUN apt-get -y upgrade
RUN apt install --no-install-recommends -y ebtables && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y net-tools && rm -rf /var/lib/apt/lists/*;
COPY $CNMS_BUILD_DIR/azure-cnms /usr/bin/azure-cnms
RUN chmod +x /usr/bin/azure-cnms
CMD ["/usr/bin/azure-cnms"]
