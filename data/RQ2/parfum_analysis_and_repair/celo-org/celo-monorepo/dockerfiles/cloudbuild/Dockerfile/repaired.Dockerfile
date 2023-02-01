FROM node:12

RUN apt-get update -y
RUN apt-get install lsb-release libudev-dev libusb-dev -y --no-install-recommends apt-utils && rm -rf /var/lib/apt/lists/*;

# Install Kubernetes, as per https://kubernetes.io/docs/tasks/tools/install-kubectl/
RUN apt-get install --no-install-recommends -y apt-transport-https && \
    curl -f -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && \
    apt-get install --no-install-recommends -y kubectl && rm -rf /var/lib/apt/lists/*;

RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update -y && apt-get install --no-install-recommends google-cloud-sdk -y && rm -rf /var/lib/apt/lists/*;

CMD ["/bin/sh"]
