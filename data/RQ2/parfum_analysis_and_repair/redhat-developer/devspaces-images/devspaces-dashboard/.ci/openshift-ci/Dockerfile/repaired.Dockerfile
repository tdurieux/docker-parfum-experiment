#!/bin/bash
#
# Copyright (c) 2012-2020 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#
# Contributors:
#   Red Hat, Inc. - initial API and implementation
# Dockerfile to bootstrap build and test in openshift-ci
FROM registry.ci.openshift.org/openshift/release:golang-1.15
SHELL ["/bin/bash", "-c"]
# Install yq, kubectl, chectl tools