# Copyright 2018 Datawire. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License

################################################################
# This image is the base _runtime_ for Ambassador. No compilers or
# other toolchains, just the basics and the external Golang
# dependencies that Ambassador needs. It's used as a base image in the
# main Dockerfile, so that we can use the Docker cache to more
# effectively dodge network issues re-downloading the Golang stuff.
#
# If you have to change this - notably, if you switch to a new rev of
# either Golang dependency - you _must_ update AMBASSADOR_BASE_IMAGE
# in the Makefile, then run "make docker-update-base" to build and push
# the new image.

ARG ENVOY_BASE_IMAGE
FROM $ENVOY_BASE_IMAGE

ENV AMBASSADOR_ROOT=/ambassador
WORKDIR ${AMBASSADOR_ROOT}

# This is the best place to add things that you want to guarantee will
# always be present in Ambassador pods.
RUN apk --no-cache add bash curl python3 jq

# Grab kubewatch
RUN curl -o /usr/bin/kubewatch -q https://s3.amazonaws.com/datawire-static-files/kubewatch/0.3.17/linux/amd64/kubewatch
RUN chmod +x /usr/bin/kubewatch

# Grab ambex
RUN curl -o /usr/bin/ambex https://s3.amazonaws.com/datawire-static-files/ambex/0.1.1/ambex
RUN chmod 755 /usr/bin/ambex

# Grab kubectl
RUN curl -o /usr/bin/kubectl -L https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod 755 /usr/bin/kubectl
