FROM circleci/golang:1.11.5-stretch-node

RUN sudo apt-get update && sudo apt-get install -y --no-install-recommends apt-transport-https && rm -rf /var/lib/apt/lists/*;

ENV CLOUD_SDK_REPO=cloud-sdk-stretch

RUN echo "deb https://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
  curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
  sudo apt-get update && \
  sudo apt-get install --no-install-recommends -y google-cloud-sdk && \
  gcloud --version && rm -rf /var/lib/apt/lists/*;

RUN sudo npm install -g firebase-tools && \
  firebase --version && npm cache clean --force;

RUN curl -sfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh| sudo sh -s -- -b $(go env GOPATH)/bin v1.17.1 && \
  golangci-lint --version

RUN sudo apt-get update && \
  sudo apt-get install --no-install-recommends -y postgresql-client && \
  psql --version && rm -rf /var/lib/apt/lists/*;
