FROM python:3.9.9
RUN apt-get update && apt-get install --no-install-recommends -y \
    curl \
    postgresql-client && rm -rf /var/lib/apt/lists/*;

# Install AWS CLI
RUN pip install --no-cache-dir awscli

# Install GCP CLI
RUN curl -f -sSL https://sdk.cloud.google.com | bash
RUN ln -f -s /root/google-cloud-sdk/bin/gsutil /usr/bin/gsutil

# Install Azure CLI
RUN curl -f -sL https://aka.ms/InstallAzureCLIDeb | bash

VOLUME /mnt/data
COPY ./start.sh /
CMD /start.sh
