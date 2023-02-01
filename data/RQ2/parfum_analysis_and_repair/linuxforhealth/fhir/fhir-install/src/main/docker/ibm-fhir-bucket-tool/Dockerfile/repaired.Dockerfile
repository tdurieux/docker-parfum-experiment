# ----------------------------------------------------------------------------
# (C) Copyright IBM Corp. 2021
#
# SPDX-License-Identifier: Apache-2.0
# ----------------------------------------------------------------------------
# Stage: Base

# IBM Semeru Runtimes provides Non-official docker images. These are maintained by IBM.
# The link to Semeru is at https://hub.docker.com/r/ibmsemeruruntime/open-11-jdk
FROM ibmsemeruruntime/open-11-jdk:ubi_min-jre as base

# Create the base working directory
RUN mkdir -p /opt/ibm/fhir/bucket/workarea

# Copy in the relevant artifacts in a single command
COPY ./run.sh ./target/fhir-bucket-*-cli.jar ./target/LICENSE /opt/ibm/fhir/bucket/

# ----------------------------------------------------------------------------
# Stage: Runnable

FROM registry.access.redhat.com/ubi8/ubi-minimal

ARG FHIR_VERSION=4.10.0

# The following labels are required: 
LABEL name='IBM FHIR Server - Bucket Tool'
LABEL vendor='IBM'
LABEL version="$FHIR_VERSION"
LABEL summary="Image for IBM FHIR Server - Bucket Tool with OpenJ9 and UBI 8"
LABEL description="The IBM FHIR Server - Bucket Tool manages the IBM FHIR Server operations and generates synthetic load."

# Environment variables