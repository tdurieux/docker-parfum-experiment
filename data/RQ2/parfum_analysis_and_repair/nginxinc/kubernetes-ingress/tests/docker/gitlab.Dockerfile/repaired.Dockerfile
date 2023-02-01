FROM python:3.9

ARG GCLOUD_VERSION=364.0.0
ARG HELM_VERSION=3.5.4

RUN apt-get update && apt-get install --no-install-recommends -y curl git jq apache2-utils \
	&& curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
	&& chmod +x ./kubectl \
	&& mv ./kubectl /usr/local/bin \
	&& curl -f -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_VERSION}-linux-x86_64.tar.gz \
	&& tar xvzf google-cloud-sdk-${GCLOUD_VERSION}-linux-x86_64.tar.gz \
	&& mv google-cloud-sdk /usr/lib/ \
	&& curl -f -LO https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
	&& tar -zxvf helm-v${HELM_VERSION}-linux-amd64.tar.gz \
	&& mv linux-amd64/helm /usr/local/bin/helm && rm google-cloud-sdk-${GCLOUD_VERSION}-linux-x86_64.tar.gz && rm -rf /var/lib/apt/lists/*;

WORKDIR /workspace/tests

COPY --link tests/requirements.txt /workspace/tests/
RUN pip install --no-cache-dir -r requirements.txt

COPY --link tests /workspace/tests
COPY --link deployments /workspace/deployments

ENV PATH="/usr/lib/google-cloud-sdk/bin:${PATH}"

ENTRYPOINT ["python3", "-m", "pytest"]
