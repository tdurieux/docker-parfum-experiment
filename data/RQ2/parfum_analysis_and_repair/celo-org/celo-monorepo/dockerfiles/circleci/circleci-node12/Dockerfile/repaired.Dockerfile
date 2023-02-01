FROM circleci/node:12

RUN sudo apt-get update -y
RUN sudo apt-get install --no-install-recommends lsb-release libudev-dev libusb-dev libusb-1.0-0 rsync -y && rm -rf /var/lib/apt/lists/*;

# Install Kubernetes, as per https://kubernetes.io/docs/tasks/tools/install-kubectl/
RUN sudo apt-get install --no-install-recommends -y apt-transport-https && \
  curl -f -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
  echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list && \
  sudo apt-get update && \
  sudo apt-get install --no-install-recommends -y kubectl && rm -rf /var/lib/apt/lists/*;

RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
  echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
  curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
  sudo apt-get update -y && sudo apt-get install --no-install-recommends google-cloud-sdk -y && rm -rf /var/lib/apt/lists/*;

CMD ["/bin/sh"]
