# Basic Python3.6 install
FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get install --no-install-recommends -y curl lsb-release gnupg git python3.6 python3-pip python3-boto && rm -rf /var/lib/apt/lists/*;

RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update -y && apt-get install --no-install-recommends -y google-cloud-sdk && rm -rf /var/lib/apt/lists/*;

COPY lib /root/portal_client/lib/
COPY portal_client /root/portal_client/
COPY DESC /root/portal_client/
COPY setup.py /root/portal_client/

RUN cd /root/portal_client && \
    pip3 install --no-cache-dir .

