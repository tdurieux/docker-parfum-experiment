FROM ubuntu:20.04
MAINTAINER Trevor Dolby <tdolby@uk.ibm.com> (@tdolby)

# docker build -t ace-full:12.0.4.0-ubuntu -f Dockerfile.ubuntu .

ARG DOWNLOAD_URL=http://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/integration/12.0.4.0-ACE-LINUX64-DEVELOPER.tar.gz
ARG PRODUCT_LABEL=ace-12.0.4.0

# Prevent errors about having no terminal when using apt-get
ENV DEBIAN_FRONTEND noninteractive

# Install ACE v12.0.4.0 and accept the license
RUN apt-get update && apt-get install -y --no-install-recommends curl && \
    mkdir /opt/ibm && echo Downloading package ${DOWNLOAD_URL} && \
    curl -f ${DOWNLOAD_URL} | tar zx --directory /opt/ibm && \
    mv /opt/ibm/${PRODUCT_LABEL} /opt/ibm/ace-12 && \
    /opt/ibm/ace-12/ace make registry global accept license deferred && rm -rf /var/lib/apt/lists/*;

# Configure the system
RUN echo "ACE_12:" > /etc/debian_chroot \
  && echo ". /opt/ibm/ace-12/server/bin/mqsiprofile" >> /root/.bashrc

# mqsicreatebar prereqs; need to run "Xvfb -ac :99 &" and "export DISPLAY=:99"
RUN apt-get -y --no-install-recommends install libgtk2.0-0 libxtst6 xvfb libswt-gtk-4-java && rm -rf /var/lib/apt/lists/*;

# Set BASH_ENV to source mqsiprofile when using docker exec bash -c
ENV BASH_ENV=/opt/ibm/ace-12/server/bin/mqsiprofile

# Create a user to run as, create the ace workdir, and chmod script files
RUN useradd --uid 1001 --create-home --home-dir /home/aceuser --shell /bin/bash -G mqbrkrs,sudo aceuser \
  && su - aceuser -c "export LICENSE=accept && . /opt/ibm/ace-12/server/bin/mqsiprofile && mqsicreateworkdir /home/aceuser/ace-server" \
  && echo ". /opt/ibm/ace-12/server/bin/mqsiprofile" >> /home/aceuser/.bashrc

# aceuser
USER 1001
ENTRYPOINT ["bash"]
