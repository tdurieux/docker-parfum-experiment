FROM ubuntu:18.04

ENV PYTHONPATH $PYTHONPATH:/usr/local/google-cloud-sdk/platform/google_appengine
# NOTE: the Cloud SDK component manager is disabled in this install, so
# `gcloud components install app-engine-python` does not work. So, use:
RUN apt-get update && apt-get install --no-install-recommends -y wget python-pip vim git && rm -rf /var/lib/apt/lists/*;

# Setup google-cloud-sdk.
WORKDIR /usr/local/
RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-277.0.0-linux-x86_64.tar.gz
RUN tar -zxf google-cloud-sdk-277.0.0-linux-x86_64.tar.gz && rm google-cloud-sdk-277.0.0-linux-x86_64.tar.gz
RUN rm -f google-cloud-sdk-277.0.0-linux-x86_64.tar.gz
ENV PATH $PATH:/usr/local/google-cloud-sdk/bin
RUN gcloud components install app-engine-python app-engine-python-extras

COPY test_requirements.txt /
RUN pip install --no-cache-dir -r /test_requirements.txt
RUN pip install --no-cache-dir coveralls pyopenssl==19.1.0
RUN pip install --no-cache-dir django==1.2 jinja2==2.6
COPY . /workspace
