FROM internalpcfplatformautomation/platform-automation:packages

# remove azure cli
RUN pip3 install --no-cache-dir pip-autoremove
RUN pip-autoremove -y azure-cli

# remove pip
RUN pip3 uninstall -y pip-autoremove pip

# remove gcloud CLI
RUN rm -Rf /usr/local/bin/gcloud
RUN rm -Rf /root/google-cloud-sdk
