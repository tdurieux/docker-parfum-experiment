FROM ubuntu:latest

# https://cloud.google.com/sdk/docs/quickstart-debian-ubuntu
RUN apt-get update \
 && apt-get install --no-install-recommends -y \
        curl \
        git \
        lsb-release \
        openssh-client \
 && export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" \
 && echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" > /etc/apt/sources.list.d/google-cloud-sdk.list \
 && curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
 && apt-get update \
 && apt-get install --no-install-recommends -y google-cloud-sdk \
 && gcloud config set core/disable_usage_reporting true \
 && gcloud config set component_manager/disable_update_check true \
 && gcloud --version \
 && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --user-group --shell /bin/bash gitbundle

RUN mkdir -p /home/gitbundle/.ssh
COPY gitbundle.sh /home/gitbundle/gitbundle.sh
RUN chown -R gitbundle:gitbundle /home/gitbundle

USER gitbundle
RUN git config --global http.cookiefile /home/gitbundle/.gitcookies

WORKDIR /home/gitbundle
ENTRYPOINT [ "/home/gitbundle/gitbundle.sh" ]
