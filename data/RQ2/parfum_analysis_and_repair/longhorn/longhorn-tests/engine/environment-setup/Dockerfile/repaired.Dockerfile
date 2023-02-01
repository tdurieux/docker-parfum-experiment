FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y python openssh-client curl python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip google-api-python-client packet-python

RUN curl -f -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-119.0.0-linux-x86_64.tar.gz
RUN tar zxvf google-cloud-sdk-119.0.0-linux-x86_64.tar.gz && rm google-cloud-sdk-119.0.0-linux-x86_64.tar.gz
ENV CLOUDSDK_CORE_DISABLE_PROMPTS="1"
RUN ./google-cloud-sdk/install.sh
RUN ./google-cloud-sdk/bin/gcloud components update

ADD *.py ./

ENTRYPOINT ["python"]

