# Docker descriptor for XSK
# Copyright (c) 2022 SAP SE or an SAP affiliate company and XSK contributors

# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, v2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
  
# SPDX-FileCopyrightText: 2022 SAP SE or an SAP affiliate company and XSK contributors
# SPDX-License-Identifier: Apache-2.0

# (Optional) JDK_TYPE could be `default-jdk` or `external-jdk`
ARG JDK_TYPE=default-jdk

FROM dirigiblelabs/xsk-kyma-runtime-base as base

COPY target/ROOT.war /usr/local/tomcat/webapps/

FROM base AS xsk-external-jdk
# If JDK_TYPE is set to `external-jdk`, then the JDK_HOME is required and it should point to the home directory of the jdk