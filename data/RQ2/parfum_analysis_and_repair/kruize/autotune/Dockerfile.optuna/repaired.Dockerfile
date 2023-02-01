#
# Copyright (c) 2021, 2021 Red Hat, IBM Corporation and others.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
##########################################################
#            Runtime Docker Image
##########################################################
# Use ubi-minimal as the base image
FROM registry.access.redhat.com/ubi8/ubi-minimal:8.4

ARG AUTOTUNE_VERSION
ARG NUM_TRIALS=100
ARG NUM_JOBS=1

WORKDIR /opt/app

# Install packages needed for python to function correctly
# Create the non root user, same as the one used in the build phase.
RUN microdnf install -y python3 \
    && microdnf update -y \
    && microdnf -y install shadow-utils \
    && adduser -u 1001 -G root -s /usr/sbin/nologin default \
    && chown -R 1001:0 /opt/app \
    && chmod -R g+rw /opt/app \
    && microdnf -y remove shadow-utils \
    && microdnf clean all

# Switch to the non root user
USER 1001

# Install optuna to the default user
RUN python3 -m pip install --user optuna requests scikit-optimize jsonschema

LABEL name="Kruize Autotune Optuna" \
      vendor="Red Hat" \
      version=${AUTOTUNE_VERSION} \
      release=${AUTOTUNE_VERSION} \
      run="docker run --rm -it -p 8080:8080 <image_name:tag>" \
      summary="Docker Image for Autotune with ubi-minimal" \
      description="For more information on this image please see https://github.com/kruize/autotune/blob/master/README.md"

# Copy ML hyperparameter tuning code