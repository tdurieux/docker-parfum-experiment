FROM gcr.io/cloud-builders/gcloud

RUN apt-get -q update && apt-get install --no-install-recommends -qqy \
  jq \
  gettext-base && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT []