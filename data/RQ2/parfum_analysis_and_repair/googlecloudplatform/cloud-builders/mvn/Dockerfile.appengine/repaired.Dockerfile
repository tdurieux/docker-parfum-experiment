ARG PROJECT_ID="cloud-builders"
FROM gcr.io/${PROJECT_ID}/mvn:latest

# install python
RUN apt-get update -y && apt-get install --no-install-recommends python3 -y && rm -rf /var/lib/apt/lists/*;

# install cloud sdk into appengine-maven-plugin cache
RUN set -eux; \
  mkdir -p ~/.cache/google-cloud-tools-java/managed-cloud-sdk/LATEST; \
  cd ~/.cache/google-cloud-tools-java/managed-cloud-sdk/LATEST; \
  curl -f https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.tar.gz --output google-cloud-sdk.tar.gz; \
  tar -xzvf google-cloud-sdk.tar.gz; \
  ./google-cloud-sdk/bin/gcloud components install app-engine-java; \
  rm google-cloud-sdk.tar.gz;
