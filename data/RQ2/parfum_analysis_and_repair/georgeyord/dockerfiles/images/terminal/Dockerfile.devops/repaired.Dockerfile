# GoTTY terminal with additional DevOps tools
FROM georgeyord/terminal:latest

ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

# kubectl
RUN curl -f -L "https://dl.k8s.io/release/$( curl -f -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
      -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl

# aws
# helm
# kubectx / kubens
# python
# terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
    && apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    && curl -f https://baltocdn.com/helm/signing.asc | sudo apt-key add - \
    && echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list \
    && apt-get update --quiet > /dev/null \
    && apt-get install -y --no-install-recommends --assume-yes -qq \
      awscli \
      helm \
      kubectx \
      python3-dev \
      python3-setuptools \
      python3-pip \
      python3-yaml \
      terraform \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# gcloud cli
RUN curl -f https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz \
    && mkdir -p /usr/local/gcloud \
    && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
    && /usr/local/gcloud/google-cloud-sdk/install.sh \
    && gcloud version && rm /tmp/google-cloud-sdk.tar.gz

# ansible
RUN pip3 install --no-cache-dir --upgrade pip \
    && pip3 install --no-cache-dir ansible \
    && ansible --version

# k9s
RUN curl -f -sS https://webinstall.dev/k9s | bash
