FROM debian:jessie-slim
MAINTAINER Niranjan Rajendran <me@niranjan.io>

RUN apt-get clean -y && apt-get update -y
RUN apt-get install --no-install-recommends -y curl apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN echo "deb https://packages.cloud.google.com/apt cloud-sdk-jessie main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN apt-get update -y && apt-get install --no-install-recommends -y google-cloud-sdk && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean -y

CMD gcloud info
