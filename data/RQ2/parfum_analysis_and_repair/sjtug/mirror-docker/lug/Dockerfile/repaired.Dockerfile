FROM htfy96/lug:release-0.12.2

RUN apt-get update && apt-get install --no-install-recommends rsync awscli python3-pip rsync python wget git jq -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir bandersnatch
RUN wget -O gcloud.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-183.0.0-linux-x86_64.tar.gz?hl=zh-cn && tar xavf gcloud.tar.gz && rm -rf gcloud.tar.gz && ./google-cloud-sdk/install.sh
