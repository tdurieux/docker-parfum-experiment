FROM ubuntu:20.04
RUN apt-get update -y && apt-get install --no-install-recommends -y curl unzip python3 less && rm -rf /var/lib/apt/lists/*;
RUN curl -f "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    curl -f "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-380.0.0-linux-x86_64.tar.gz" -o "google-cloud.tar.gz" && \
    tar -xf google-cloud.tar.gz && \
    ./google-cloud-sdk/install.sh -q && \
    rm -rf awscliv2.zip google-cloud.tar.gz && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    curl -f -sL https://aka.ms/InstallAzureCLIDeb | bash
ENV PATH=/google-cloud-sdk/bin:$PATH