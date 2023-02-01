FROM cloudfoundry/cflinuxfs2

COPY \
       om-linux \
       semver-linux \
       yaml_patch_linux \
       cf \
       cliaas-linux \
       pivnet-cli \
       govc \
       stemcell-downloader \
       steamroll \
       jq \
       terraform \
       /usr/local/bin/

COPY terraforming-azure/ /home/vcap/app/terraforming-azure

RUN cp /usr/local/bin/yaml_patch_linux /usr/local/bin/yaml-patch
# gcloud SDK
RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list && \
 curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
apt-get -y update && sudo apt-get -y install --no-install-recommends google-cloud-sdk && rm -rf /var/lib/apt/lists/*;

# pip
RUN apt-get install -y --no-install-recommends libffi-dev python-cffi python-pip python-dev software-properties-common python-software-properties && rm -rf /var/lib/apt/lists/*;
# vim
RUN ln -s /usr/bin/vim.tiny /usr/local/bin/vim
# UAA Client
RUN gem install cf-uaac --no-ri --no-rdoc
# Ensure latest version of six
RUN pip install --no-cache-dir six --upgrade
# AWS Client
RUN pip install --no-cache-dir awscli
# Openstack Client
RUN apt-get -y update && \
 apt-get -y --no-install-recommends install curl build-essential && \
 apt-get -y --no-install-recommends install python python-dev python-pip software-properties-common && \
 pip install --no-cache-dir --upgrade pip setuptools wheel && \
 pip install --no-cache-dir python-openstackclient python-neutronclient && rm -rf /var/lib/apt/lists/*;

# Azure Client
RUN echo "deb https://packages.microsoft.com/repos/azure-cli/ wheezy main" | sudo tee /etc/apt/sources.list.d/azure-cli.list && \
 curl -f -L https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add - && \
sudo apt-get -y install --no-install-recommends apt-transport-https && \
sudo apt-get -y update && sudo apt-get -y install --no-install-recommends azure-cli && rm -rf /var/lib/apt/lists/*;

# Clean up
RUN apt-get remove -y python-dev apt-transport-https && \
apt-get -y clean && apt-get -y autoremove --purge && rm -rf /etc/apt/ && \
rm -rf /tmp/* && \
find /var/lib/apt/lists -type f | xargs rm -f && \
find /var/cache/debconf -type f -name '*-old' | xargs rm -f && \
find /var/log -type f -user root | xargs rm -rf && \
for file in $(find /var/log -type f -user syslog); do echo > $file; done
