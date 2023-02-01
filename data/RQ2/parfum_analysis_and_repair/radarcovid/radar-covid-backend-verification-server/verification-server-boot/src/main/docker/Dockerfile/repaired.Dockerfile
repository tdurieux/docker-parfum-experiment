#
# Copyright (c) 2020 Gobierno de España
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# SPDX-License-Identifier: MPL-2.0
#

FROM adoptopenjdk:11-jre-openj9 as builder
WORKDIR /verification
COPY  [ "${project.artifactId}-${project.version}-exec.jar", "app.jar" ]
RUN java -Djarmode=layertools -jar app.jar extract

FROM adoptopenjdk:11-jre-openj9
WORKDIR /verification

# Metadata