#
# Copyright (c) 2019 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at:
#
#     https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#
# Contributors:
#   Red Hat, Inc. - initial API and implementation
#

FROM @fromImage@:latest-java11
LABEL location="src/main/docker/subdir"
EXPOSE 8080/tcp
COPY maven/*.jar /opt/app.jar
ENTRYPOINT [ "java", "-jar", "/opt/app.jar" ]
