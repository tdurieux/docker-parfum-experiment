#ARGS
ARG NODE_TAG=${NODE_TAG}

FROM node:${NODE_TAG}

ARG APPPATH=${APPPATH}
ENV APPPATH ${APPPATH}
# Install modules
RUN apt-get update --fix-missing && apt-get install --no-install-recommends -y curl nano git dos2unix && rm -rf /var/lib/apt/lists/*;
WORKDIR $APPPATH
ADD ./cliinstall.sh /opt/dev-tools/cliinstall.sh
RUN chmod +x /opt/dev-tools/cliinstall.sh
RUN dos2unix /opt/dev-tools/cliinstall.sh
