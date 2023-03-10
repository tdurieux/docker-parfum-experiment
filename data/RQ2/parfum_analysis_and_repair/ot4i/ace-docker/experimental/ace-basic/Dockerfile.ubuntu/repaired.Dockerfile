FROM ubuntu:20.04
MAINTAINER Trevor Dolby <tdolby@uk.ibm.com> (@tdolby)

# Build and run:
#
# docker build -t ace-basic:12.0.4.0-ubuntu -f Dockerfile .
# docker run -e LICENSE=accept -p 7600:7600 -p 7800:7800 --rm -ti ace-basic:12.0.4.0-ubuntu
#
# Can also mount a volume for the work directory:
#
# docker run -e LICENSE=accept -v /what/ever/dir:/home/aceuser/ace-server -p 7600:7600 -p 7800:7800 --rm -ti ace-basic:12.0.4.0-ubuntu
#
# This might require a local directory with the right permissions, or changing the userid further down . . .

ARG USERNAME
ARG PASSWORD
ARG DOWNLOAD_URL=http://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/integration/12.0.4.0-ACE-LINUX64-DEVELOPER.tar.gz
ARG PRODUCT_LABEL=ace-12.0.4.0

# Prevent errors about having no terminal when using apt-get
ENV DEBIAN_FRONTEND noninteractive

# Install ACE v12.0.4.0 and accept the license
RUN apt-get update && apt-get install -y --no-install-recommends curl && \
    mkdir /opt/ibm && echo Downloading package ${DOWNLOAD_URL} && \
    if [ -z $USERNAME ]; then \
    curl -f ${DOWNLOAD_URL}; else curl -f -u ${USERNAME}:{PASSWORD} ${DOWNLOAD_URL}; fi | \
    tar zx --exclude=tools --exclude server/bin/TADataCollector.sh --exclude server/transformationAdvisor/ta-plugin-ace.jar --directory /opt/ibm && \
    mv /opt/ibm/${PRODUCT_LABEL} /opt/ibm/ace-12 && \
    /opt/ibm/ace-12/ace make registry global accept license deferred && rm -rf /var/lib/apt/lists/*;

# Create a user to run as, create the ace workdir, and chmod script files
RUN useradd --uid 1001 --create-home --home-dir /home/aceuser --shell /bin/bash -G mqbrkrs,sudo aceuser \
  && su - aceuser -c "export LICENSE=accept && . /opt/ibm/ace-12/server/bin/mqsiprofile && mqsicreateworkdir /home/aceuser/ace-server" \
  && echo ". /opt/ibm/ace-12/server/bin/mqsiprofile" >> /home/aceuser/.bashrc

# aceuser
USER 1001

# Set entrypoint to run the server
ENTRYPOINT ["bash", "-c", ". /opt/ibm/ace-12/server/bin/mqsiprofile && IntegrationServer -w /home/aceuser/ace-server"]
