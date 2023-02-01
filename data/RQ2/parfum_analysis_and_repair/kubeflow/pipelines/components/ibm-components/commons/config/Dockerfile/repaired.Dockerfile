FROM python:3.6-slim

# Directories for model codes and secrets
RUN mkdir /app

# Install curl and kubectl
RUN apt-get update
RUN apt-get install --no-install-recommends -y curl gnupg && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN curl -f -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update
RUN apt-get install --no-install-recommends -y kubectl && rm -rf /var/lib/apt/lists/*;

# Directory for secrets
COPY src/config.py /app
