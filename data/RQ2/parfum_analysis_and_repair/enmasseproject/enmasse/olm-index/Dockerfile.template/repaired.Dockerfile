#
# Copyright 2018-2019, EnMasse authors.
# License: Apache License 2.0 (see the file LICENSE or http://apache.org/licenses/LICENSE-2.0.html).
#
FROM ${OLM_INDEX_IMAGE_PREVIOUS}

ARG version
ARG revision
ARG maven_version
ENV VERSION=${version} MAVEN_VERSION=${maven_version} REVISION=${revision}

# Add new manifests