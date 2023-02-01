FROM selenium/standalone-chrome:3.141.59-oxygen

USER root

ARG CLOUD_SDK_VERSION=279.0.0
ENV CLOUD_SDK_VERSION=$CLOUD_SDK_VERSION

ARG INSTALL_COMPONENTS=kubectl
ENV PATH "$PATH:/opt/google-cloud-sdk/bin/"
RUN apt-get update -qqy && apt-get install --no-install-recommends -qqy \
        curl \
        gcc \
        python-dev \
        python-pip \
        apt-transport-https \
        lsb-release \
        openssh-client \
        git \
        gnupg \
    && \
    pip install --no-cache-dir -U crcmod && \
    export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb https://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" > /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update && apt-get install --no-install-recommends -y google-cloud-sdk=${CLOUD_SDK_VERSION}-0 $INSTALL_COMPONENTS && \
    rm -rf /var/lib/apt/lists/* /tmp/* /usr/share/locale/* /usr/share/i18n/locales/*


RUN curl -f --silent --show-error --location https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

USER seluser

RUN gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true
