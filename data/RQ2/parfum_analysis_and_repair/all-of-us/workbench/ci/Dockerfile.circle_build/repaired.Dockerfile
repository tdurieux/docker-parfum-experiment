# To build and deploy, from this directory:
# $ docker build -f Dockerfile.circle_build -t allofustest/workbench:buildimage-X.Y.Z .
# Test out the new image with:
# $ docker run -it allofustest/workbench:buildimage-X.Y.Z /bin/bash
# Update all mentions of allofustest/workbench:buildimage-X.Y.Z in
# .circleci/circle.yml by incrementing the numbers. Using the new values, run:
# $ docker login  # interactive prompts
# $ docker push allofustest/workbench:buildimage-X.Y.Z
# For permission to push, request to be added to the DockerHub repository.
# Include your changes to circle.yml in the PR that uses the build image.

# This image should be kept synchronized with deploy/Dockerfile.

# Note: we depend on dockerize being installed on this image.
#
# We use OpenJDK 8, Node, and some common browsers from CircleCI's base image
# see: https://circleci.com/docs/2.0/circleci-images/#language-image-variants
# and https://discuss.circleci.com/t/legacy-convenience-image-deprecation
FROM cimg/openjdk:8.0-browsers

USER circleci

ENV CLOUD_SDK_VERSION 392.0.0

RUN cd && \
  wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz -O gcloud.tgz && \
  tar -xf gcloud.tgz && \
  ./google-cloud-sdk/install.sh  --quiet && \
  ~/google-cloud-sdk/bin/gcloud components install app-engine-java && \
  rm -rf gcloud.tgz

RUN sudo apt-get update
RUN sudo apt-get install -y --no-install-recommends gettext ruby default-mysql-client python3-pip wait-for-it && rm -rf /var/lib/apt/lists/*;
RUN sudo pip install --upgrade pip pylint

ENV PATH=/home/circleci/node/bin:/home/circleci/google-cloud-sdk/bin:$PATH

RUN curl -f https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 > /tmp/cloud_sql_proxy \
  && sudo mv /tmp/cloud_sql_proxy /usr/local/bin && sudo chmod +x /usr/local/bin/cloud_sql_proxy

# It never makes sense for Gradle to run a daemon within a docker container.
ENV GRADLE_OPTS="-Dorg.gradle.daemon=false"

ENV GRADLE_VERSION 6.7.1

RUN wget "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" -O /tmp/gradle.zip \
  && sudo unzip /tmp/gradle.zip -d /opt/gradle
ENV PATH="/opt/gradle/gradle-${GRADLE_VERSION}/bin:${PATH}"

# Force a lower concurrent-ruby version, as we only have Ruby 2.3.
RUN sudo gem install jira-ruby
