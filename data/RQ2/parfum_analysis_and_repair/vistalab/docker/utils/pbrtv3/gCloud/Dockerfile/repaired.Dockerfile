FROM vistalab/pbrt-v3-spectral

ENV DEBIAN_FRONTEND noninteractive

# Install the Google Cloud SDK.

RUN apt-get update && apt-get install -y -qq --no-install-recommends wget unzip python php5-mysql php5-cli php5-cgi openjdk-7-jre-headless openssh-client python-openssl && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y gcc python-dev python-setuptools && rm -rf /var/lib/apt/lists/*;
RUN easy_install -U pip
RUN pip install --no-cache-dir -U crcmod

WORKDIR /

ENV HOME /
ENV CLOUDSDK_PYTHON_SITEPACKAGES 1
RUN wget --no-check-certificate https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.zip && unzip google-cloud-sdk.zip && rm google-cloud-sdk.zip
RUN google-cloud-sdk/install.sh --usage-reporting=true --path-update=true --bash-completion=true --rc-path=/.bashrc --additional-components app-engine-java app-engine-python app kubectl alpha beta gcd-emulator pubsub-emulator cloud-datastore-emulator app-engine-go


# Disable updater check for the whole installation.
# Users won't be bugged with notifications to update to the latest version of gcloud.
RUN google-cloud-sdk/bin/gcloud config set --installation component_manager/disable_update_check true

# Disable updater completely.
# Running `gcloud components update` doesn't really do anything in a union FS.
# Changes are lost on a subsequent run.
RUN sed -i -- 's/\"disable_updater\": false/\"disable_updater\": true/g' /google-cloud-sdk/lib/googlecloudsdk/core/config.json


RUN mkdir /.ssh
ENV PATH /google-cloud-sdk/bin:$PATH
VOLUME ["/.config"]
CMD ["/bin/bash"]

COPY syncAndRender.sh /
COPY cloudRenderPBRT2ISET.sh /


